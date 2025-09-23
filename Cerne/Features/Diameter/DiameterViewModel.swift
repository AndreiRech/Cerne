//
//  DiameterViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 09/09/25.
//

import SwiftUI
import ARKit
import SceneKit

@Observable
class DiameterViewModel: NSObject, DiameterViewModelProtocol, ObservableObject, ARSCNViewDelegate {
    
    var result: Double? = nil
    var shouldNavigate: Bool = false
    var treeImage: UIImage
    
    var startNode: SCNNode?
    var endNode: SCNNode?
    var lineNode: SCNNode?
    var textNode: SCNNode?
    var guidelineNode: SCNNode?
    
    var cameraService: CameraServiceProtocol
    var errorMessage: String?
    
    var showInfo: Bool = true
    var showAddPointHint: Bool = false
    var placePointTrigger: Bool = false
    
    let sceneView = ARSCNView()
    private var hasRunOnce = false

    let onboardingService: OnboardingServiceProtocol
    
    init(cameraService: CameraServiceProtocol, treeImage: UIImage, onboardingService: OnboardingServiceProtocol) {
        self.cameraService = cameraService
        self.onboardingService = onboardingService
        self.treeImage = treeImage
        super.init()
        setupSceneView()
    }
    
    private func setupSceneView() {
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    func runSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical]
        configuration.environmentTexturing = .automatic
        
        if hasRunOnce {
            sceneView.session.run(configuration)
        } else {
            sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            hasRunOnce = true
        }
    }
    
    func pauseSession() {
        sceneView.session.pause()
    }
    
    func addPointAtCenter(in sceneView: ARSCNView) {
        let centerPoint = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
        
        guard let query = sceneView.raycastQuery(from: centerPoint, allowing: .estimatedPlane, alignment: .horizontal) else {
            return
        }
        
        let results = sceneView.session.raycast(query)
        guard let result = results.first else {
            return
        }
        
        let position = SCNVector3(
            result.worldTransform.columns.3.x,
            result.worldTransform.columns.3.y,
            result.worldTransform.columns.3.z
        )
        
        if startNode == nil {
            startNode = createSphere(at: position)
            sceneView.scene.rootNode.addChildNode(startNode!)
            
        } else if endNode == nil {
            endNode = createSphere(at: position)
            sceneView.scene.rootNode.addChildNode(endNode!)
            
            lineNode = drawRuler(from: startNode!.position, to: endNode!.position)
            sceneView.scene.rootNode.addChildNode(lineNode!)
            
            let distance = distanceBetween(startNode!.position, endNode!.position)
            
            let midPoint = SCNVector3(
                (startNode!.position.x + endNode!.position.x) / 2,
                (startNode!.position.y + endNode!.position.y) / 2 + 0.01, // Um pouco acima da linha
                (startNode!.position.z + endNode!.position.z) / 2
            )
            
            let text = String(format: "%.2f m", distance)
            textNode = addText(text, at: midPoint)
            sceneView.scene.rootNode.addChildNode(textNode!)
            
            self.result = Double(distance)
        }
    }
    
    func triggerPointPlacement() {
        placePointTrigger = true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let startNode = self.startNode, self.endNode == nil else {
            DispatchQueue.main.async {
                self.guidelineNode?.removeFromParentNode()
                self.guidelineNode = nil
            }
            return
        }
        
        DispatchQueue.main.async {
            let centerPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
            guard let query = self.sceneView.raycastQuery(from: centerPoint, allowing: .estimatedPlane, alignment: .horizontal),
                  let result = self.sceneView.session.raycast(query).first else {
                return
            }
            
            let worldPosition = SCNVector3(
                result.worldTransform.columns.3.x,
                result.worldTransform.columns.3.y,
                result.worldTransform.columns.3.z
            )
            
            self.guidelineNode?.removeFromParentNode()
            self.guidelineNode = self.drawLine(from: startNode.position, to: worldPosition, color: .white)
            self.sceneView.scene.rootNode.addChildNode(self.guidelineNode!)
        }
    }
    
    func resetNodes() {
        startNode?.removeFromParentNode()
        endNode?.removeFromParentNode()
        lineNode?.removeFromParentNode()
        textNode?.removeFromParentNode()
        guidelineNode?.removeFromParentNode()
        
        startNode = nil
        endNode = nil
        lineNode = nil
        textNode = nil
        guidelineNode = nil
        result = nil
    }
    
    func finishMeasurement() {
        if let distance = result, distance > 0 {
            shouldNavigate = true
        }
    }
    
    func createSphere(at position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: sphere)
        node.position = position
        return node
    }
    
    func distanceBetween(_ start: SCNVector3, _ end: SCNVector3) -> Float {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let dz = end.z - start.z
        return sqrt(dx*dx + dy*dy + dz*dz)
    }
    
    func addText(_ text: String, at position: SCNVector3) -> SCNNode {
        let textGeometry = SCNText(string: text, extrusionDepth: 0.01)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        textGeometry.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        
        let node = SCNNode(geometry: textGeometry)
        node.scale = SCNVector3(0.005, 0.005, 0.005)
        node.position = position
        
        let constraint = SCNBillboardConstraint()
        node.constraints = [constraint]
        
        return node
    }
    
    func drawRuler(from start: SCNVector3, to end: SCNVector3, interval: Float = 0.1) -> SCNNode {
        let rulerNode = SCNNode()
        let mainLine = drawLine(from: start, to: end)
        rulerNode.addChildNode(mainLine)
        
        let dx = end.x - start.x
        let dy = end.y - start.y
        let dz = end.z - start.z
        let length = sqrt(dx*dx + dy*dy + dz*dz)
        let steps = Int(length / interval) // Calcula quantos "ticks" de 10cm cabem na linha.
        if steps == 0 { return rulerNode }
        
        let stepVector = SCNVector3(dx / Float(steps), dy / Float(steps), dz / Float(steps))
        
        for i in 0...steps {
            let tickPosition = SCNVector3(
                start.x + stepVector.x * Float(i),
                start.y + stepVector.y * Float(i),
                start.z + stepVector.z * Float(i)
            )
            let tick = drawTick(at: tickPosition, size: 0.005)
            rulerNode.addChildNode(tick)
        }
        
        return rulerNode
    }
    
    private func drawLine(from start: SCNVector3, to end: SCNVector3, color: UIColor = .yellow) -> SCNNode {
        let vertices: [SCNVector3] = [start, end]
        let source = SCNGeometrySource(vertices: vertices)
        let indices: [Int32] = [0, 1]
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.firstMaterial?.diffuse.contents = color
        return SCNNode(geometry: geometry)
    }
    
    private func drawTick(at position: SCNVector3, size: Float) -> SCNNode {
        let tickGeometry = SCNCylinder(radius: 0.0005, height: CGFloat(size))
        tickGeometry.firstMaterial?.diffuse.contents = UIColor.white
        let tickNode = SCNNode(geometry: tickGeometry)
        tickNode.position = position
        tickNode.eulerAngles.x = .pi / 2
        return tickNode
    }
}
