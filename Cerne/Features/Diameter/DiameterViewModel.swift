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
    
    var result: Float? = nil
    var shouldNavigate: Bool = false
    var treeImage: UIImage?
    
    var startNode: SCNNode?
    var endNode: SCNNode?
    var lineNode: SCNNode?
    var textNode: SCNNode?
    
    var cameraService: CameraServiceProtocol
    var errorMessage: String?
    
    init(startNode: SCNNode? = nil, endNode: SCNNode? = nil, lineNode: SCNNode? = nil, textNode: SCNNode? = nil, cameraService: CameraServiceProtocol, treeImage: UIImage?) {
        self.startNode = startNode
        self.endNode = endNode
        self.lineNode = lineNode
        self.textNode = textNode
        self.cameraService = cameraService
        self.treeImage = treeImage
    }
    
    func onAppear() {
        Task {
            if await cameraService.requestPermissions() {
                cameraService.startSession()
            } else {
                errorMessage = cameraService.errorMessage
            }
        }
    }
    
    func onDisappear() {
        cameraService.stopSession()
    }
    
    func handleTap(at location: CGPoint, in sceneView: ARSCNView) {
        guard let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .any) else {
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
                (startNode!.position.x + endNode!.position.x)/2,
                (startNode!.position.y + endNode!.position.y)/2 + 0.01,
                (startNode!.position.z + endNode!.position.z)/2
            )
            
            textNode = addText("\(String(format: "%.2f", distance)) m", at: midPoint)
            sceneView.scene.rootNode.addChildNode(textNode!)
            
            print("📝 Distance between points: \(String(format: "%.2f", distance)) meters")
            self.result = distance

        } else {
            resetNodes()
        }
    }
    
    func resetNodes() {
        startNode?.removeFromParentNode()
        endNode?.removeFromParentNode()
        lineNode?.removeFromParentNode()
        textNode?.removeFromParentNode()
        
        startNode = nil
        endNode = nil
        lineNode = nil
        textNode = nil
    }
    
    func finishMeasurement() {
        if let distance = result {
            if distance > 0 {
                shouldNavigate = true
            }
        } 
    }
    
    // MARK: - Helper Methods
    func createSphere(at position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: sphere)
        node.position = position
        node.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: sphere, options: nil))
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
        textGeometry.flatness = 0.2
        
        let node = SCNNode(geometry: textGeometry)
        node.scale = SCNVector3(0.005, 0.005, 0.005)
        node.position = position
        
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = .Y
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
        let steps = Int(length / interval)
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
    
    private func drawLine(from start: SCNVector3, to end: SCNVector3) -> SCNNode {
        let vertices: [SCNVector3] = [start, end]
        let source = SCNGeometrySource(vertices: vertices)
        let indices: [Int32] = [0, 1]
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.firstMaterial?.diffuse.contents = UIColor.yellow
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
