//
//  MockServicePlaceholder.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import Foundation
import AVFoundation
import UIKit
import Combine
@testable import Cerne

class MockCameraService: CameraServiceProtocol {
    @Published var capturedImage: UIImage?
    var capturedImagePublisher: Published<UIImage?>.Publisher { $capturedImage }
    
    var wasCalled: Bool = false
    var isCorrect: Bool = true
    var shouldFail: Bool
    var errorMessage: String?
    var message: String?
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        wasCalled = true
        return AVCaptureVideoPreviewLayer()
    }()
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func setupSession() {
        wasCalled = true
        message = "Setup"
    }
    
    func requestPermissions() async -> Bool {
        wasCalled = true
        
        if shouldFail {
            errorMessage = "Erro"
            isCorrect = false
            return false
        }
        
        return true
    }
    
    func startSession() {
        wasCalled = true
        message = "Started"
    }
    
    func stopSession() {
        wasCalled = true
        message = "Stoped"
    }
    
    func capturePhoto() {
        wasCalled = true
        
        if shouldFail {
            errorMessage = "Erro"
            isCorrect = false
        }
        
        message = "Captured"
    }
    
    func clearImage() {
        wasCalled = true
        message = "Cleared"
    }
}
