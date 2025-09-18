//
//  UserLocation.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import Foundation
import CoreLocation

struct UserLocation: Equatable {
    
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
