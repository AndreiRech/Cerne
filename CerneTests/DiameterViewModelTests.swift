////
////  DiameterViewModelTests.swift
////  CerneTests
////
////  Created by Maria Santellano on 19/09/25.
////
//
//import Foundation
//import Testing
//@testable import Cerne
//import ARKit
//import SceneKit
//import UIKit
//
//// MARK: - Testes
//
//@MainActor
//struct DiameterViewModelTests {
//    
//    let mockCameraService = MockCameraService(shouldFail: false)
//
//    @Test func shouldStartWithDefaultValues() {
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(),
//            treeSpecies: ""
//        )
//        
//        #expect(viewModel.result == nil)
//        #expect(viewModel.shouldNavigate == false)
//        #expect(viewModel.showInfo == true)
//        #expect(viewModel.showAddPointHint == false)
//        #expect(viewModel.placePointTrigger == false)
//    }
//    
//    @Test func triggerPointPlacementShouldSetFlagTrue() {
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(),
//            treeSpecies: ""
//        )
//        
//        viewModel.placePointButtonTapped()
//        
//        #expect(viewModel.pointCo)
//    }
//    
//    @Test func resetNodesShouldClearAllReferencesAndScene() {
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(),
//            treeSpecies: ""
//        )
//        
//        let node = viewModel.createSphere(at: SCNVector3(0,0,0))
//        viewModel.startNode = node
//        viewModel.endNode = node
//        viewModel.lineNode = node
//        viewModel.textNode = node
//        viewModel.guidelineNode = node
//        viewModel.result = 42
//        viewModel.sceneView.scene.rootNode.addChildNode(node)
//        
//        viewModel.resetNodes()
//        
//        #expect(viewModel.startNode == nil)
//        #expect(viewModel.endNode == nil)
//        #expect(viewModel.lineNode == nil)
//        #expect(viewModel.textNode == nil)
//        #expect(viewModel.guidelineNode == nil)
//        #expect(viewModel.result == nil)
//        #expect(node.parent == nil) // removido da cena
//    }
//    
//    // MARK: - Finalização
//    
//    @Test func finishMeasurementShouldNavigateWhenResultIsPositive() {
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(),
//            treeSpecies: ""
//        )
//        viewModel.result = 2.5
//        viewModel.finishMeasurement()
//        #expect(viewModel.shouldNavigate == true)
//    }
//    
//    @Test func finishMeasurementShouldNotNavigateWhenResultIsNilOrZeroOrNegative() {
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(),
//            treeSpecies: ""
//        )
//        
//        viewModel.result = nil
//        viewModel.finishMeasurement()
//        #expect(viewModel.shouldNavigate == false)
//        
//        viewModel.result = 0
//        viewModel.finishMeasurement()
//        #expect(viewModel.shouldNavigate == false)
//        
//        viewModel.result = -1
//        viewModel.finishMeasurement()
//        #expect(viewModel.shouldNavigate == false)
//    }
//    
//    // MARK: - Métodos Auxiliares de Geometria
//    
//    @Test func createSphereShouldReturnRedSphere() {
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(),
//            treeSpecies: ""
//        )
//        
//        let node = viewModel.createSphere(at: SCNVector3(1,2,3))
//        
//        #expect(node.geometry is SCNSphere)
//        let color = (node.geometry as? SCNSphere)?
//            .firstMaterial?.diffuse.contents as? UIColor
//        #expect(color == UIColor.red)
//    }
//    
//    @Test func addTextShouldReturnTextNodeWithCorrectSettings() {
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(),
//            treeSpecies: ""
//        )
//        
//        let point1 = SCNVector3(0, 0, 0)
//        let point2 = SCNVector3(0, 0, 3)
//        
//        // When
//        let distance = viewModel.distanceBetween(point1, point2)
//        
//        // Then
//        #expect(distance == 3.0)
//        
//    }
//    
//    @Test func shouldAddText() async {
//        //Given
//        let mockCameraService = MockCameraService(shouldFail: false)
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(),
//            treeSpecies: ""
//        )
//        let text = "Test"
//        let position = SCNVector3(1, 2, 3)
//        
//        //When
//        let node = viewModel.addText(text, at: position)
//        
//        //Then
//        #expect(node.position.x == position.x)
//        #expect(node.position.y == position.y)
//        #expect(node.position.z == position.z)
//        #expect(node.position.x == 1.0)
//        #expect(node.position.y == 2.0)
//        #expect(node.position.z == 3.0)
//        
//        #expect(node.geometry is SCNText)
//        let string = (node.geometry as? SCNText)?.string as? String
//        #expect(string == "Test")
//        #expect(node.constraints?.first is SCNBillboardConstraint)
//    }
//    
//    @Test func distanceBetweenShouldCalculateEuclideanDistance() {
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(), 
//            treeSpecies: ""
//        )
//        
//        let a = SCNVector3(0,0,0)
//        let b = SCNVector3(3,4,0)
//        
//        let d = viewModel.distanceBetween(a, b)
//        
//        #expect(d == 5.0)
//    }
//    
//    @Test func drawRulerShouldAddTicksWhenLongEnough() {
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(),
//            treeSpecies: ""
//        )
//        
//        let ruler = viewModel.drawRuler(
//            from: SCNVector3(0,0,0),
//            to: SCNVector3(0,0,0.5)
//        )
//        
//        #expect(ruler.childNodes.count > 1)
//    }
//    
//    @Test func drawRulerShouldNotAddTicksWhenTooShort() {
//        let viewModel = DiameterViewModel(
//            treeImage: UIImage(),
//            userDefaultService: MockUserDefaultService(),
//            treeSpecies: ""
//        )
//        
//        let ruler = viewModel.drawRuler(
//            from: SCNVector3(0,0,0),
//            to: SCNVector3(0,0,0.05)
//        )
//        
//        #expect(ruler.childNodes.count == 1)
//    }
//}
