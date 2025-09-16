//
//  ARServiceProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import Foundation
import ARKit
import RealityKit
import Combine

protocol ARServiceProtocol {
    var arView: ARView { get }
    var distancePublisher: PassthroughSubject<Float, Never> { get }
    
    func start(showOverlay: Bool = false)
    func stop()
}
