//
//  MapViewModelProtocol.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import SwiftUI
import MapKit

protocol MapViewModelProtocol {
    var position: MapCameraPosition { get }
    var userLocation: UserLocation? { get }
    var pins: [Pin] { get }
    var selectedPin: Pin? { get set }
    
    func getPins()
    func onMapAppear()
}
