//
//  DiameterViewModelTests.swift
//  CerneTests
//
//  Created by Maria Santellano on 19/09/25.
//

import Foundation
import Testing
@testable import Cerne
import ARKit
import SceneKit
import UIKit

// MARK: - Mocks

/// Mock simples de CameraServiceProtocol (apenas para injeção de dependência)
class DummyCameraService: CameraServiceProtocol {
    var errorMessage: String?
    
    @Published var capturedImage: UIImage?
    var capturedImagePublisher: Published<UIImage?>.Publisher { $capturedImage }

    func requestPermissions() async -> Bool { true }
    func startSession() {}
    func stopSession() {}
    func capturePhoto() {}
    func clearImage() {}
    var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
}

// MARK: - Testes

@MainActor
struct DiameterViewModelTests {
    
    // MARK: - Estado Inicial
    
    @Test func shouldStartWithDefaultValues() {
        let viewModel = DiameterViewModel(
            cameraService: DummyCameraService(),
            treeImage: UIImage()
        )
        
        #expect(viewModel.result == nil)
        #expect(viewModel.shouldNavigate == false)
        #expect(viewModel.showInfo == true)
        #expect(viewModel.showAddPointHint == false)
        #expect(viewModel.placePointTrigger == false)
        #expect(viewModel.startNode == nil)
        #expect(viewModel.endNode == nil)
    }
    
    @Test func triggerPointPlacementShouldSetFlagTrue() {
        let viewModel = DiameterViewModel(
            cameraService: DummyCameraService(),
            treeImage: UIImage()
        )
        
        viewModel.triggerPointPlacement()
        
        #expect(viewModel.placePointTrigger == true)
    }
    
    // MARK: - Reset
    
    @Test func resetNodesShouldClearAllReferencesAndScene() {
        let viewModel = DiameterViewModel(
            cameraService: DummyCameraService(),
            treeImage: UIImage()
        )
        
        let node = viewModel.createSphere(at: SCNVector3(0,0,0))
        viewModel.startNode = node
        viewModel.endNode = node
        viewModel.lineNode = node
        viewModel.textNode = node
        viewModel.guidelineNode = node
        viewModel.result = 42
        viewModel.sceneView.scene.rootNode.addChildNode(node)
        
        viewModel.resetNodes()
        
        #expect(viewModel.startNode == nil)
        #expect(viewModel.endNode == nil)
        #expect(viewModel.lineNode == nil)
        #expect(viewModel.textNode == nil)
        #expect(viewModel.guidelineNode == nil)
        #expect(viewModel.result == nil)
        #expect(node.parent == nil) // removido da cena
    }
    
    // MARK: - Finalização
    
    @Test func finishMeasurementShouldNavigateWhenResultIsPositive() {
        let viewModel = DiameterViewModel(
            cameraService: DummyCameraService(),
            treeImage: UIImage()
        )
        viewModel.result = 2.5
        viewModel.finishMeasurement()
        #expect(viewModel.shouldNavigate == true)
    }
    
    @Test func finishMeasurementShouldNotNavigateWhenResultIsNilOrZeroOrNegative() {
        let viewModel = DiameterViewModel(
            cameraService: DummyCameraService(),
            treeImage: UIImage()
        )
        
        viewModel.result = nil
        viewModel.finishMeasurement()
        #expect(viewModel.shouldNavigate == false)
        
        viewModel.result = 0
        viewModel.finishMeasurement()
        #expect(viewModel.shouldNavigate == false)
        
        viewModel.result = -1
        viewModel.finishMeasurement()
        #expect(viewModel.shouldNavigate == false)
    }
    
    // MARK: - Métodos Auxiliares de Geometria
    
    @Test func createSphereShouldReturnRedSphere() {
        let viewModel = DiameterViewModel(
            cameraService: DummyCameraService(),
            treeImage: UIImage()
        )
        
        let node = viewModel.createSphere(at: SCNVector3(1,2,3))
        
        #expect(node.geometry is SCNSphere)
        let color = (node.geometry as? SCNSphere)?
            .firstMaterial?.diffuse.contents as? UIColor
        #expect(color == UIColor.red)
    }
    
    @Test func addTextShouldReturnTextNodeWithCorrectSettings() {
        let viewModel = DiameterViewModel(
            cameraService: DummyCameraService(),
            treeImage: UIImage()
        )
        
        let node = viewModel.addText("Hello", at: SCNVector3(0,0,0))
        
        #expect(node.geometry is SCNText)
        let string = (node.geometry as? SCNText)?.string as? String
        #expect(string == "Hello")
        #expect(node.constraints?.first is SCNBillboardConstraint)
    }
    
    @Test func distanceBetweenShouldCalculateEuclideanDistance() {
        let viewModel = DiameterViewModel(
            cameraService: DummyCameraService(),
            treeImage: UIImage()
        )
        
        let a = SCNVector3(0,0,0)
        let b = SCNVector3(3,4,0)
        
        let d = viewModel.distanceBetween(a, b)
        
        #expect(d == 5.0)
    }
    
    @Test func drawRulerShouldAddTicksWhenLongEnough() {
        let viewModel = DiameterViewModel(
            cameraService: DummyCameraService(),
            treeImage: UIImage()
        )
        
        let ruler = viewModel.drawRuler(
            from: SCNVector3(0,0,0),
            to: SCNVector3(0,0,0.5)
        )
        
        #expect(ruler.childNodes.count > 1)
    }
    
    @Test func drawRulerShouldNotAddTicksWhenTooShort() {
        let viewModel = DiameterViewModel(
            cameraService: DummyCameraService(),
            treeImage: UIImage()
        )
        
        let ruler = viewModel.drawRuler(
            from: SCNVector3(0,0,0),
            to: SCNVector3(0,0,0.05)
        )
        
        #expect(ruler.childNodes.count == 1)
    }
}
