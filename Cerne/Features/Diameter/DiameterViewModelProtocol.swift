//
//  DiameterViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 09/09/25.
//

import SwiftUI
import ARKit
import SceneKit

protocol DiameterViewModelProtocol: AnyObject {
    var cameraService: CameraServiceProtocol { get }
    var userDefaultService: UserDefaultServiceProtocol { get }
    var errorMessage: String? { get }

    func addPointAtCenter(in sceneView: ARSCNView)
    func resetNodes()
    func createSphere(at position: SCNVector3) -> SCNNode
    func distanceBetween(_ start: SCNVector3, _ end: SCNVector3) -> Float
    func addText(_ text: String, at position: SCNVector3) -> SCNNode
}
