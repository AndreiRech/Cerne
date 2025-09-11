//
//  MapViewModelProtocol.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import SwiftUI
import MapKit

protocol MapViewModelProtocol {
    var position: MapCameraPosition { get set }
    var userLocation: UserLocation? { get set }
    var pins: [Pin] { get set }
    var selectedPin: Pin? { get set }
    var pinService: PinServiceProtocol { get }
    
    func getPins()
    
    func addPin(image: Data?, species: String, height: Double, dap: Double)
    
    func refreshLocation()
}
