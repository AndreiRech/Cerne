//
//  CameraServiceProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import Foundation
import AVFoundation
import UIKit
import Combine

protocol CameraServiceProtocol {
    var capturedImagePublisher: Published<UIImage?>.Publisher { get }
    var previewLayer: AVCaptureVideoPreviewLayer { get }
    var errorMessage: String? { get }
    
    func requestPermissions() async -> Bool
    func startSession()
    func stopSession()
    func capturePhoto()
    func clearImage()
    func setupSession()
}
