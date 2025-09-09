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
    var wasCalled: Bool = false
    var isCorrect: Bool = true
    var shouldFail: Bool
    var errorMessage: String?

    var capturedImagePublisher: Published<UIImage?>.Publisher { $_capturedImage }
    @Published private var _capturedImage: UIImage?
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        wasCalled = true
        return AVCaptureVideoPreviewLayer()
    }()
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
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
    }
    
    func stopSession() {
        wasCalled = true
    }
    
    func capturePhoto() {
        wasCalled = true
        
        if shouldFail {
            errorMessage = "Erro"
            isCorrect = false
        }
    }
    
    func clearImage() {
        wasCalled = true
    }
}
