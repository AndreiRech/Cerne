//
//  MotionService.swift
//  Cerne
//
//  Created by Andrei Rech on 09/09/25.
//

import Foundation
import Combine
import CoreMotion

class MotionService: MotionServiceProtocol {
    private let motionManager = CMMotionManager()
    
    @Published private var angleInDegrees: Double = 0.0
    var anglePublisher: Published<Double>.Publisher { $angleInDegrees }
    
    init() {
        setupMotionManager()
    }
    
    private func setupMotionManager() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Erro: Device Motion não está disponível.")
            return
        }
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
    }
    
    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let data = data else { return }
            
            let g = data.gravity
            let angle = atan2(g.z, g.y)
            
            if angle > 0 {
                self.angleInDegrees = (angle * 180 / .pi ) - 90
            } else {
                self.angleInDegrees = (angle * 180 / .pi) + 270
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
