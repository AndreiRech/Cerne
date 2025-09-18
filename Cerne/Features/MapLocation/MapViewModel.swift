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
    var isShowingDetails: Bool = false
    
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
        } catch {
            print("Was not possible to fetch pins: \(error)")
        }
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
