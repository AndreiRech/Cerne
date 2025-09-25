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
    var userLocation: UserLocation? { get }
    var usablePins: [Pin] { get }
    var metaballs: [Metaball] { get }
    var selectedPin: Pin? { get set }
    var currentZoomLevel: Double { get }
    var normalizedZoomLevel: Double { get }
    
    func getPins()
    func onMapAppear()
    func updateMapRegion(zoomLevel: Double, region: MKCoordinateRegion)
}
