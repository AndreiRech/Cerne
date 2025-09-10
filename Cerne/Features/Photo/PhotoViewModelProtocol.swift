//
//  PhotoViewModelProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 09/09/25.
//

import Foundation
import UIKit

protocol PhotoViewModelProtocol {
    var cameraService: CameraServiceProtocol { get }
    var treeAPIService: TreeAPIServiceProtocol { get }
    
    var isLoading: Bool { get }
    var errorMessage: String? { get set }
    var capturedImage: UIImage? { get }
    var identifiedTree: TreeResponse? { get }
    
    func onAppear()
    func onDisappear()
    func capturePhoto()
    func retakePhoto()
    
    func identifyTree(image: UIImage) async
}
