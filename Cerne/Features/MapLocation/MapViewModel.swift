//
//  MapViewModel.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 08/09/25.
//

import Foundation
import MapKit
import Combine
import _MapKit_SwiftUI

final class MapViewModel: MapViewModelProtocol {
    
    @Published var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -30.0346, longitude: -51.2177),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    ))

    private var locationService: LocationServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(locationService: LocationServiceProtocol = LocationService()) {
        self.locationService = locationService
        self.locationService.requestLocationAuthorization()
        setupLocationSubscription()
    }

    private func setupLocationSubscription() {
        locationService.userLocationPublisher
            .compactMap { $0 }
            .sink { [weak self] location in
            
                self?.position = .region(MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
            }
            .store(in: &cancellables)
    }
}
