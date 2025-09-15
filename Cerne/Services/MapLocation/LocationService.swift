//
//  LocationService.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import CoreLocation

@Observable
class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {

    private let manager = CLLocationManager()

    var userLocation: UserLocation?

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
    
        self.userLocation = UserLocation(latitude: location.coordinate.latitude,
                                         longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro no LocationService: \(error.localizedDescription)")
    }
}
