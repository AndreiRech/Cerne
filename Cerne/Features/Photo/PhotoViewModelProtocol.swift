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
    var userDefaultService: UserDefaultServiceProtocol { get }
    
    var isLoading: Bool { get }
    var errorMessage: String? { get set }
    var capturedImage: UIImage? { get set }
    var identifiedTree: TreeResponse? { get set }
    
    var showInfo: Bool { get set }
    var isMeasuring: Bool { get set }
    var shouldNavigate: Bool { get set }
    var isIdentifying: Bool { get set }
    
    func onAppear()
    func onDisappear()
    func capturePhoto()
    func retakePhoto()
    
    func identifyTree(image: UIImage) async
}
