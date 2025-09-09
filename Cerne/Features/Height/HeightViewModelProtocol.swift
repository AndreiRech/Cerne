//
//  HeightViewModelProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import Foundation
import AVFoundation
import Combine

protocol HeightViewModelProtocol: AnyObject, ObservableObject {
    var estimatedHeight: Double { get }
    var previewLayer: AVCaptureVideoPreviewLayer { get }
    var cameraService: CameraServiceProtocol { get }
    var errorMessage: String? { get }
    
    func onAppear()
    func onDisappear()
    func calculateHeight(angleInDegrees: Double)
    func startMotionUpdates()
}
