//
//  LocationService.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate, LocationServiceProtocol {

    private let manager = CLLocationManager()

    @Published var userLocation: UserLocation?
    
    var userLocationPublisher: Published<UserLocation?>.Publisher { $userLocation }

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocationAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else { return }
    
        self.userLocation = UserLocation(latitude: location.coordinate.latitude,
                                         longitude: location.coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro no LocationService: \(error.localizedDescription)")
    }
}
