//
//  MapViewModelProtocol.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import Foundation
import MapKit
import Combine
import _MapKit_SwiftUI

protocol MapViewModelProtocol: ObservableObject {
    
    var position: MapCameraPosition { get set }
    
}
