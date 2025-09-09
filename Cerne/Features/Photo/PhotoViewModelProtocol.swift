//
//  PhotoViewModelProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 09/09/25.
//

import Foundation
import UIKit

protocol PhotoViewModelProtocol {
    var estimatedHeight: Double { get }
    var cameraService: CameraServiceProtocol { get }
    var errorMessage: String? { get }
    var capturedImage: UIImage? { get }
    
    func onAppear()
    func onDisappear()
    func capturePhoto()
    func retakePhoto()
}
