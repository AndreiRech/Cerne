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
    var distancePublisher: PassthroughSubject<Float?, Never> { get }
    var interactionMode: ARInteractionMode { get set }
    
    func start(showOverlay: Bool)
    func stop()
    func addMeasurementPoint()
    func removeMeasurementPoints()
}
