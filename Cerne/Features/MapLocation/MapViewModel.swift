//
//  MapViewModel.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 08/09/25.
//

import MapKit
import Combine
import SwiftUI

@Observable
final class MapViewModel: MapViewModelProtocol {
    var position: MapCameraPosition = .automatic
    var userLocation: UserLocation?
    var usablePins: [Pin] = []
    var metaballs: [Metaball] = []
    var selectedPin: Pin?
    var currentZoomLevel: Double = 0.01
    
    private var pins: [Pin] = []
    private var currentRegion: MKCoordinateRegion?
    
    private let zoomThresholdStartMetaballs: Double = 0.002
    private let zoomThresholdFullMetaballs: Double = 0.02
    private let zoomThresholdHide: Double = 0.08
    
    private var userService: UserServiceProtocol
    private var pinService: PinServiceProtocol
    private var scannedTreeService: ScannedTreeServiceProtocol
    private var locationService: LocationServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    var normalizedZoomLevel: Double {
        let startThreshold = 0.002
        let endThreshold = 0.08
        
        let normalized = (currentZoomLevel - startThreshold) / (endThreshold - startThreshold)
        return max(0, min(1, normalized))
    }
    
    init(locationService: LocationServiceProtocol,
         pinService: PinServiceProtocol,
         userService: UserServiceProtocol,
         scannedTreeService: ScannedTreeServiceProtocol) {
        self.locationService = locationService
        self.pinService = pinService
        self.userService = userService
        self.scannedTreeService = scannedTreeService
        
        setupLocationSubscription()
    }
    
    func onMapAppear() async {
        locationService.start()
        await getPins()
    }
    
    func getPins() async {
        do {
            try await pins = pinService.fetchPins()
            updateVisualization()
        } catch {
            print("Was not possible to fetch pins: \(error)")
        }
    }
    
    func updateMapRegion(zoomLevel: Double, region: MKCoordinateRegion) {
        currentZoomLevel = zoomLevel
        currentRegion = region
        updateVisualization()
    }
    
    private func updateVisualization() {
        if currentZoomLevel < zoomThresholdStartMetaballs {
            metaballs = []
            usablePins = pins
        } else if currentZoomLevel < zoomThresholdFullMetaballs {
            let transitionProgress = (currentZoomLevel - zoomThresholdStartMetaballs) /
                                   (zoomThresholdFullMetaballs - zoomThresholdStartMetaballs)
            
            let createdMetaballs = createGradualMetaballs(from: pins, progress: transitionProgress)
            let isolatedPins = getIsolatedPins(from: pins, metaballs: createdMetaballs)
            
            metaballs = createdMetaballs
            usablePins = isolatedPins
        } else if currentZoomLevel < zoomThresholdHide {
            metaballs = createFullMetaballs(from: pins)
            usablePins = []
        } else {
            metaballs = []
            usablePins = []
        }
    }
    
    private func createGradualMetaballs(from pins: [Pin], progress: Double) -> [Metaball] {
        guard !pins.isEmpty else { return [] }
        
        let baseRadius = 0.001 + (progress * 0.005)
        
        var metaballs: [Metaball] = []
        var processedPins: Set<UUID> = []
        
        for pin in pins {
            if processedPins.contains(pin.id) {
                continue
            }
            
            let nearbyPins = findNearbyPins(from: pin, in: pins, radius: baseRadius, processed: processedPins)
            
            if nearbyPins.count >= 2 && progress > 0.3 {
                for nearPin in nearbyPins {
                    processedPins.insert(nearPin.id)
                }
                
                let centerLat = nearbyPins.map { $0.latitude }.reduce(0, +) / Double(nearbyPins.count)
                let centerLon = nearbyPins.map { $0.longitude }.reduce(0, +) / Double(nearbyPins.count)
                
                let metaball = Metaball(
                    coordinate: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                    pinCount: nearbyPins.count,
                    pins: nearbyPins,
                    radius: calculateMetaballRadius(pinCount: nearbyPins.count, progress: progress),
                    intensity: calculateMetaballIntensity(pinCount: nearbyPins.count, progress: progress)
                )
                
                metaballs.append(metaball)
            }
        }
        
        return mergeCloseMetaballs(metaballs, progress: progress)
    }
    
    private func createFullMetaballs(from pins: [Pin]) -> [Metaball] {
        guard !pins.isEmpty else { return [] }
        
        let normalizedZoom = (currentZoomLevel - zoomThresholdFullMetaballs) /
        (zoomThresholdHide - zoomThresholdFullMetaballs)
        let baseRadius = 0.003 + (normalizedZoom * 0.015)
        
        var metaballs: [Metaball] = []
        var processedPins: Set<UUID> = []
        
        for pin in pins {
            if processedPins.contains(pin.id) {
                continue
            }
            
            var clusterPins: [Pin] = [pin]
            processedPins.insert(pin.id)
            
            var centerLat = pin.latitude
            var centerLon = pin.longitude
            
            var foundNewPins = true
            while foundNewPins {
                foundNewPins = false
                
                for otherPin in pins {
                    if !processedPins.contains(otherPin.id) {
                        let distance = calculateDistance(
                            lat1: centerLat,
                            lon1: centerLon,
                            lat2: otherPin.latitude,
                            lon2: otherPin.longitude
                        )
                        
                        let dynamicRadius = baseRadius * (1.0 + Double(clusterPins.count) * 0.1)
                        
                        if distance < dynamicRadius {
                            clusterPins.append(otherPin)
                            processedPins.insert(otherPin.id)
                            
                            centerLat = clusterPins.map { $0.latitude }.reduce(0, +) / Double(clusterPins.count)
                            centerLon = clusterPins.map { $0.longitude }.reduce(0, +) / Double(clusterPins.count)
                            
                            foundNewPins = true
                        }
                    }
                }
            }
            
            let metaball = Metaball(
                coordinate: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                pinCount: clusterPins.count,
                pins: clusterPins,
                radius: calculateMetaballRadius(pinCount: clusterPins.count, progress: 1.0),
                intensity: calculateMetaballIntensity(pinCount: clusterPins.count, progress: 1.0)
            )
            
            metaballs.append(metaball)
        }
        
        return mergeCloseMetaballs(metaballs, progress: 1.0)
    }
    
    private func findNearbyPins(from centerPin: Pin, in pins: [Pin], radius: Double, processed: Set<UUID>) -> [Pin] {
        var nearbyPins: [Pin] = [centerPin]
        
        for pin in pins {
            if pin.id != centerPin.id && !processed.contains(pin.id) {
                let distance = calculateDistance(
                    lat1: centerPin.latitude,
                    lon1: centerPin.longitude,
                    lat2: pin.latitude,
                    lon2: pin.longitude
                )
                
                if distance < radius {
                    nearbyPins.append(pin)
                }
            }
        }
        
        return nearbyPins
    }
    
    private func getIsolatedPins(from pins: [Pin], metaballs: [Metaball]) -> [Pin] {
        let metaballPinIds = Set(metaballs.flatMap { $0.pins.map { $0.id } })
        return pins.filter { !metaballPinIds.contains($0.id) }
    }
    
    private func mergeCloseMetaballs(_ metaballs: [Metaball], progress: Double) -> [Metaball] {
        guard metaballs.count > 1 else { return metaballs }
        
        var mergedMetaballs: [Metaball] = []
        var processedIndices: Set<Int> = []
        
        let mergeThreshold = 0.002 + (progress * 0.008)
        
        for (index, metaball) in metaballs.enumerated() {
            if processedIndices.contains(index) {
                continue
            }
            
            var combinedPins = metaball.pins
            var combinedCount = metaball.pinCount
            processedIndices.insert(index)
            
            for (otherIndex, otherMetaball) in metaballs.enumerated() {
                if otherIndex > index && !processedIndices.contains(otherIndex) {
                    let distance = calculateDistance(
                        lat1: metaball.coordinate.latitude,
                        lon1: metaball.coordinate.longitude,
                        lat2: otherMetaball.coordinate.latitude,
                        lon2: otherMetaball.coordinate.longitude
                    )
                    
                    if distance < mergeThreshold {
                        combinedPins.append(contentsOf: otherMetaball.pins)
                        combinedCount += otherMetaball.pinCount
                        processedIndices.insert(otherIndex)
                    }
                }
            }
            
            let centerLat = combinedPins.map { $0.latitude }.reduce(0, +) / Double(combinedPins.count)
            let centerLon = combinedPins.map { $0.longitude }.reduce(0, +) / Double(combinedPins.count)
            
            let mergedMetaball = Metaball(
                coordinate: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                pinCount: combinedCount,
                pins: combinedPins,
                radius: calculateMetaballRadius(pinCount: combinedCount, progress: progress),
                intensity: calculateMetaballIntensity(pinCount: combinedCount, progress: progress)
            )
            
            mergedMetaballs.append(mergedMetaball)
        }
        
        return mergedMetaballs
    }
    
    private func calculateMetaballRadius(pinCount: Int, progress: Double) -> Double {
        let baseRadius = 0.001
        let countFactor = Double(pinCount) * 0.0003
        let progressFactor = progress * 0.002
        return baseRadius + countFactor + progressFactor
    }
    
    private func calculateMetaballIntensity(pinCount: Int, progress: Double) -> Double {
        let baseIntensity = 0.4 + (progress * 0.3)
        let countBonus = min(0.3, Double(pinCount) * 0.05)
        return min(1.0, baseIntensity + countBonus)
    }
    
    private func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let deltaLat = abs(lat1 - lat2)
        let deltaLon = abs(lon1 - lon2)
        return sqrt(deltaLat * deltaLat + deltaLon * deltaLon)
    }
    
    private func setupLocationSubscription() {
        locationService.userLocationPublisher
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                
                self.userLocation = location
                self.position = .region(
                    MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            }
            .store(in: &cancellables)
    }
}
