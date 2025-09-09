//
//  HeightViewModel.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import SwiftUI
import CoreMotion
import AVFoundation

class HeightViewModel: HeightViewModelProtocol, ObservableObject {
    private let motionManager = CMMotionManager()
    
    @Published var estimatedHeight: Double = 0.0
    
    let userHeight: Double
    let distanceToTree: Double
    var cameraService: CameraServiceProtocol
    var errorMessage: String?
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return cameraService.previewLayer
    }
    
    init(cameraService: CameraServiceProtocol, userHeight: Double, distanceToTree: Double) {
        self.cameraService = cameraService
        self.userHeight = userHeight
        self.distanceToTree = distanceToTree
    }
    
    func onAppear() {
        Task {
            if await cameraService.requestPermissions() {
                cameraService.startSession()
            } else {
                errorMessage = cameraService.errorMessage
            }
        }
        startMotionUpdates()
    }
    
    func onDisappear() {
        cameraService.stopSession()
        stopMotionUpdates()
    }
    
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                guard let self = self, let data = data else { return }
                
                let g = data.gravity
                let angle = atan2(g.z, g.y)
                
                let angleInDegrees: Double
                if angle > 0 {
                    angleInDegrees = (angle * 180 / .pi ) - 90
                } else {
                    angleInDegrees = (angle * 180 / .pi) + 270
                }
                
                self.calculateHeight(angleInDegrees: angleInDegrees)
            }
        }
    }
    
    func calculateHeight(angleInDegrees: Double) {
        let angleElevation = 90.0 - angleInDegrees
        let angleInRadians = angleElevation * .pi / 180
        let calculatedHeight = self.distanceToTree * tan(angleInRadians) + self.userHeight
        self.estimatedHeight = calculatedHeight
    }
    
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}


