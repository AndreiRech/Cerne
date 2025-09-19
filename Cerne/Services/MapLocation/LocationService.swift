//
//  LocationService.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import CoreLocation
import Combine

@Observable
class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {
    private let manager = CLLocationManager()
    private let userLocationSubject = PassthroughSubject<UserLocation, Never>()
    var userLocation: UserLocation?
    
    var userLocationPublisher: AnyPublisher<UserLocation, Never> {
        userLocationSubject.eraseToAnyPublisher()
    }

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else { return }
    
        let updatedLocation = UserLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        self.userLocation = updatedLocation
        
        userLocationSubject.send(updatedLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro no LocationService: \(error.localizedDescription)")
    }
}
