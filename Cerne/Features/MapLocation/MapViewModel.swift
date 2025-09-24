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
    private let zoomThresholdIndividual: Double = 0.005
    private let zoomThresholdHide: Double = 0.05
    
    private var userService: UserServiceProtocol
    private var pinService: PinServiceProtocol
    private var scannedTreeService: ScannedTreeServiceProtocol
    private var locationService: LocationServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func onMapAppear() {
        locationService.start()
        getPins()
    }
    
    func getPins() {
        do {
            try pins = pinService.fetchPins()
            usablePins = pins
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
        if currentZoomLevel < zoomThresholdIndividual {
            metaballs = []
            usablePins = pins
        } else if currentZoomLevel < zoomThresholdHide {
            metaballs = createMetaballs(from: pins)
        } else {
            metaballs = []
            usablePins = []
        }
    }
    
    private func createMetaballs(from pins: [Pin]) -> [Metaball] {
        guard !pins.isEmpty else { return [] }
        
        let normalizedZoom = (currentZoomLevel - zoomThresholdIndividual) /
        (zoomThresholdHide - zoomThresholdIndividual)
        let baseRadius = 0.001 + (normalizedZoom * 0.01)
        
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
            
            let radius = calculateMetaballRadius(pinCount: clusterPins.count, zoomLevel: normalizedZoom)
            let intensity = calculateMetaballIntensity(pinCount: clusterPins.count)
            
            let metaball = Metaball(
                coordinate: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                pinCount: clusterPins.count,
                pins: clusterPins,
                radius: radius,
                intensity: intensity
            )
            
            metaballs.append(metaball)
        }
        
        return mergeCloseMetaballs(metaballs, zoomLevel: normalizedZoom)
    }
    
    private func mergeCloseMetaballs(_ metaballs: [Metaball], zoomLevel: Double) -> [Metaball] {
        guard metaballs.count > 1 else { return metaballs }
        
        var mergedMetaballs: [Metaball] = []
        var processedIndices: Set<Int> = []
        
        let mergeThreshold = 0.002 + (zoomLevel * 0.008)
        
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
                    
                    let combinedRadius = (metaball.radius + otherMetaball.radius) * 0.5
                    
                    if distance < mergeThreshold + combinedRadius {
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
                radius: calculateMetaballRadius(pinCount: combinedCount, zoomLevel: zoomLevel),
                intensity: calculateMetaballIntensity(pinCount: combinedCount)
            )
            
            mergedMetaballs.append(mergedMetaball)
        }
        
        return mergedMetaballs
    }
    
    private func calculateMetaballRadius(pinCount: Int, zoomLevel: Double) -> Double {
        let baseRadius = 0.001
        let countFactor = Double(pinCount) * 0.0002
        let zoomFactor = zoomLevel * 0.5
        return baseRadius + countFactor + zoomFactor
    }
    
    private func calculateMetaballIntensity(pinCount: Int) -> Double {
        let intensity = min(1.0, 0.3 + (Double(pinCount) * 0.05))
        return intensity
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
