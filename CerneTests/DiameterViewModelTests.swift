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
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
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
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
        )
        
        viewModel.triggerPointPlacement()
        
        #expect(viewModel.placePointTrigger == true)
    }
    
    @Test func shouldStopSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
        )
        
        // When
        let request = await mockCameraService.requestPermissions()
        
        viewModel.onAppear()
        await Task.yield()
        
        viewModel.onDisappear()
        
        // Then
        #expect(request)
        #expect(mockCameraService.wasCalled)
        #expect(mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == nil)
    }
    
    @Test func resetNodesShouldClearAllReferencesAndScene() {
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
            
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
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
        )
        viewModel.result = 2.5
        viewModel.finishMeasurement()
        #expect(viewModel.shouldNavigate == true)
    }
    
    @Test func finishMeasurementShouldNotNavigateWhenResultIsNilOrZeroOrNegative() {
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
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
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
            
        )
        
        let node = viewModel.createSphere(at: SCNVector3(1,2,3))
        
        #expect(node.geometry is SCNSphere)
        let color = (node.geometry as? SCNSphere)?
            .firstMaterial?.diffuse.contents as? UIColor
        #expect(color == UIColor.red)
    }
    
    @Test func addTextShouldReturnTextNodeWithCorrectSettings() {
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
            
        )
        
        let point1 = SCNVector3(0, 0, 0)
        let point2 = SCNVector3(0, 0, 3)
        
        // When
        let distance = viewModel.distanceBetween(point1, point2)
        
        // Then
        #expect(distance == 3.0)
        
    }
    
    @Test func shouldAddText() async {
        //Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
            
        )
        let text = "Test"
        let position = SCNVector3(1, 2, 3)
        
        //When
        let node = viewModel.addText(text, at: position)
        
        //Then
        #expect(node.position.x == position.x)
        #expect(node.position.y == position.y)
        #expect(node.position.z == position.z)
        #expect(node.position.x == 1.0)
        #expect(node.position.y == 2.0)
        #expect(node.position.z == 3.0)
        
        #expect(node.geometry is SCNText)
        let string = (node.geometry as? SCNText)?.string as? String
        #expect(string == "Hello")
        #expect(node.constraints?.first is SCNBillboardConstraint)
    }
    
    @Test func distanceBetweenShouldCalculateEuclideanDistance() {
        let viewModel = DiameterViewModel(
<<<<<<< HEAD
            cameraService: DummyCameraService(),
            treeImage: UIImage()
=======
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
            
>>>>>>> dc05cee0a4a7494143490776707cce158f0dc12e
        )
        
        let a = SCNVector3(0,0,0)
        let b = SCNVector3(3,4,0)
        
        let d = viewModel.distanceBetween(a, b)
        
        #expect(d == 5.0)
    }
    
    @Test func drawRulerShouldAddTicksWhenLongEnough() {
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage(),
            onboardingService: MockOnboardingService()
            
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
