//
//  MockARService.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import Foundation
import RealityKit
import Combine
@testable import Cerne

class MockARService: ARServiceProtocol {
    let distancePublisher = PassthroughSubject<Float?, Never>()
    var interactionMode: ARInteractionMode = .placingObjects

    var arView: ARView = ARView()
    var points: [Int] = []
    
    var shouldFail: Bool = true
    var isCorrect: Bool = true
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func start(showOverlay: Bool = false) {
        isCorrect = !shouldFail
    }
    
    func stop() {
        isCorrect = !shouldFail
    }
    
    func addMeasurementPoint() {
        points.append(1)
    }
    
    func removeMeasurementPoints() {
        points.removeAll()
    }
}
