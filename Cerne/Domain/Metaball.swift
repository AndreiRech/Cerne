//
//  Metaball.swift
//  Cerne
//
//  Created by Andrei Rech on 24/09/25.
//

import Foundation
import MapKit

struct Metaball: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let pinCount: Int
    let pins: [Pin]
    let radius: Double
    let intensity: Double
}
