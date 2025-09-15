//
//  HeightViewModelProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import Foundation
import AVFoundation
import Combine
import UIKit

protocol HeightViewModelProtocol {
    var shouldNavigate: Bool { get set }
    var estimatedHeight: Double { get }
    var previewLayer: AVCaptureVideoPreviewLayer { get }
    var cameraService: CameraServiceProtocol { get }
    var motionService: MotionServiceProtocol { get }
    var scannedTreeService: ScannedTreeServiceProtocol { get }
    var errorMessage: String? { get }
    var treeImage: UIImage? { get }
    var measuredDiameter: Float { get }
    
    var userHeight: Double { get }
    var distanceToTree: Double { get }
    var measuredDiameter: Double { get }
    var treeImage: UIImage { get }
    var userLatitude: Double { get }
    var userLongitude: Double { get }
    
    func onAppear()
    func onDisappear()
    func calculateHeight(angleInDegrees: Double)
    func finishMeasurement(estimatedHeight: Double)

}
