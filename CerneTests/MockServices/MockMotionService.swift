//
//  MockMotionService.swift
//  Cerne
//
//  Created by Andrei Rech on 09/09/25.
//

import Foundation
import AVFoundation
import UIKit
import Combine
@testable import Cerne

class MockMotionService: MotionServiceProtocol {
    @Published private var angleInDegrees: Double
    var anglePublisher: Published<Double>.Publisher { $angleInDegrees }
    
    var wasCalled: Bool = false
    var isCorrect: Bool = true
    
    init(angleInDegrees: Double = 90.0) {
        self.angleInDegrees = angleInDegrees
    }
    
    func startUpdates() {
        wasCalled = true
    }
    
    func stopUpdates() {
        wasCalled = true
    }
    
    func getCurrentAngle() -> Double {
        return angleInDegrees
    }
}
