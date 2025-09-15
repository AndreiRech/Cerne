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
    var arView: ARView = ARView()
    var distancePublisher: PassthroughSubject<Float, Never> = .init()
    
    var shouldFail: Bool = true
    var isCorrect: Bool = true
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func start() {
        isCorrect = !shouldFail
    }
    
    func stop() {
        isCorrect = !shouldFail
    }
    
    
}
