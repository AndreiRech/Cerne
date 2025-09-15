//
//  DiameterViewModelTests.swift
//  CerneTests
//
//  Created by Maria Santellano on 09/09/25.
//

import Foundation
import Testing
@testable import Cerne
import ARKit

struct DiameterViewModelTests {
    @Test func shouldStartSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage()
        )
        
        // When
        let request = await mockCameraService.requestPermissions()
        
        viewModel.onAppear()
        await Task.yield()
        
        // Then
        #expect(request)
        #expect(mockCameraService.wasCalled)
        #expect(mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == nil)
    }
    
    @Test func shouldFailStartSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: true)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage()
        )
        
        // When
        let request = await mockCameraService.requestPermissions()
        
        viewModel.onAppear()
        await Task.yield()
        
        // Then
        #expect(!request)
        #expect(mockCameraService.wasCalled)
        #expect(!mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == "Erro")
    }
    
    @Test func shouldStopSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage()
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
    
    @Test func shouldResetNodes() async {
        //Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage()
            
        )
        
        viewModel.startNode = SCNNode()
        viewModel.endNode = SCNNode()
        viewModel.lineNode = SCNNode()
        viewModel.textNode = SCNNode()
        
        //When
        viewModel.resetNodes()
        
        // Then
        #expect(viewModel.startNode == nil)
        #expect(viewModel.endNode == nil)
        #expect(viewModel.lineNode == nil)
        #expect(viewModel.textNode == nil)
    }
    
    @Test func shouldFinishMeasurement() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage()
        )
        viewModel.result = 1
        
        // When
        viewModel.finishMeasurement()
        
        // Then
        #expect(viewModel.shouldNavigate != false)
    }
    
    @Test func shouldNotFinishMeasurement() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage()
        )
        viewModel.result = 0
        
        // When
        viewModel.finishMeasurement()
        
        // Then
        #expect(viewModel.shouldNavigate == false)
    }
    
    @Test func shouldCreateSphere() async {
        //Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage()
            
        )
        let position = SCNVector3(1, 2, 3)
        
        //When
        let sphereNode = viewModel.createSphere(at: position)
        
        //Then
        #expect(sphereNode.position.x == position.x)
        #expect(sphereNode.position.y == position.y)
        #expect(sphereNode.position.z == position.z)
        #expect(sphereNode.geometry is SCNSphere)
        
    }
    
    @Test func shouldMeasureDistanceBetween() async {
        //Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage()
            
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
            treeImage: UIImage()
            
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
        
    }
    
    @Test func shouldDrawRule() async {
        //Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage()
            
        )
        
        let point1 = SCNVector3(0, 0, 0)
        let point2 = SCNVector3(0, 0, 3)
        
        //When
        let rulerNode = viewModel.drawRuler(from: point1, to: point2)
        
        //Then
        #expect(rulerNode.childNodes.count > 1)
        #expect(rulerNode.childNodes.first!.geometry != nil)
    }
    
    @Test func shouldNotDrawRule() async {
        //Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = DiameterViewModel(
            cameraService: mockCameraService,
            treeImage: UIImage()
            
        )
        
        let point1 = SCNVector3(0, 0, 0)
        let point2 = SCNVector3(0, 0, 0)
        
        //When
        let rulerNode = viewModel.drawRuler(from: point1, to: point2)
        
        //Then
        #expect(rulerNode.childNodes.count == 1)
        #expect(rulerNode.childNodes.first!.geometry != nil)
    }
    
}

