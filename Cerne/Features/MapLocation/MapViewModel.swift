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
    var pins: [Pin] = []
    var selectedPin: Pin?
    
    private var userService: UserServiceProtocol
    private var pinService: PinServiceProtocol
    private var scannedTreeService: ScannedTreeServiceProtocol
    private var locationService: LocationServiceProtocol
    
    init(locationService: LocationServiceProtocol,
         pinService: PinServiceProtocol,
         userService: UserServiceProtocol,
         scannedTreeService: ScannedTreeServiceProtocol) {
        self.locationService = locationService
        self.pinService = pinService
        self.userService = userService
        self.scannedTreeService = scannedTreeService
    }
    
    func onMapAppear() {
        locationService.start()
        refreshLocation()
        getPins()
    }
    
    func refreshLocation() {
        userLocation = locationService.userLocation
        updatePositionIfNeeded()
    }
    
    private func updatePositionIfNeeded() {
        guard let location = userLocation else { return }
        position = .region(
            MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
    
    func getPins() {
        do {
            try pins = pinService.fetchPins()
        } catch {
            print("Was not possible to fetch pins: \(error)")
        }
    }
    
}
