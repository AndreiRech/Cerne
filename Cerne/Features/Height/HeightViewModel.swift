//
//  HeightViewModel.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import SwiftUI
import CoreMotion
import AVFoundation
import Combine

@Observable
class HeightViewModel: HeightViewModelProtocol {
    let motionService: MotionServiceProtocol
    let cameraService: CameraServiceProtocol
    let scannedTreeService: ScannedTreeServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var shouldNavigate: Bool = false
    let userHeight: Double
    let distanceToTree: Double
    var estimatedHeight: Double = 0.0
    var finalHeight: Double = 0.0
    var errorMessage: String?
    
    let userHeight: Double
    let distanceToTree: Double
    let measuredDiameter: Double
    let treeImage: UIImage
    let userLatitude: Double
    let userLongitude: Double
    
    var showInfo: Bool = true
    var isMeasuring: Bool = false
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return cameraService.previewLayer
    }
    
    init(cameraService: CameraServiceProtocol, motionService: MotionServiceProtocol, scannedTreeService: ScannedTreeServiceProtocol, userHeight: Double, distanceToTree: Double, measuredDiameter: Double, treeImage: UIImage?, userLatitude: Double, userLongitude: Double) {
        self.motionService = motionService
        self.cameraService = cameraService
        self.scannedTreeService = scannedTreeService
        self.userHeight = userHeight
        self.distanceToTree = distanceToTree
        self.measuredDiameter = measuredDiameter
        self.treeImage = treeImage ?? UIImage()
        self.userLatitude = userLatitude
        self.userLongitude = userLongitude
        
        subscribeToPublishers()
    }
    
    private func subscribeToPublishers() {
        motionService.anglePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] angleInDegrees in
                self?.calculateHeight(angleInDegrees: angleInDegrees)
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        Task {
            if await cameraService.requestPermissions() {
                cameraService.startSession()
            } else {
                errorMessage = cameraService.errorMessage
            }
        }
        motionService.startUpdates()
    }
    
    func onDisappear() {
        cameraService.stopSession()
        motionService.stopUpdates()
    }
    
    func calculateHeight(angleInDegrees: Double) {
        let angleElevation = 90.0 - angleInDegrees
        let angleInRadians = angleElevation * .pi / 180
        var calculatedHeight = self.distanceToTree * tan(angleInRadians) + self.userHeight
        
        if calculatedHeight < 0 { calculatedHeight = 0 }
        
        self.estimatedHeight = calculatedHeight
    }
    
    func saveHeight() {
        isMeasuring = false
        finalHeight = estimatedHeight
    }
}


