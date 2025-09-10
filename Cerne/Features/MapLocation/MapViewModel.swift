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
    
    private var locationService: LocationServiceProtocol
    
    init(locationService: LocationServiceProtocol = LocationService()) {
        self.locationService = locationService
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
}
