//
//  ARService.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import Foundation
import ARKit
import RealityKit
import Combine
import AVFoundation

@Observable
class ARService: NSObject, ARServiceProtocol, ARSessionDelegate {
    static let shared = ARService()
    
    let arView: ARView
    let distancePublisher = PassthroughSubject<Float?, Never>()
    var interactionMode: ARInteractionMode = .placingObjects
    
    private var measurementPoints: [SIMD3<Float>] = []
    private var isSessionRunning = false
    private var currentMode: ARInteractionMode?
    
    private override init() {
        self.arView = ARView(frame: .zero)
        super.init()
        
        self.arView.session.delegate = self
        setupGestures()
    }
    
    deinit {
        cleanup()
    }
    
    private func cleanup() {
        if isSessionRunning {
            arView.session.pause()
            isSessionRunning = false
        }
        
        arView.scene.anchors.removeAll()
        measurementPoints.removeAll()
        
        arView.renderCallbacks.postProcess = nil
        currentMode = nil
    }
    
    func start(showOverlay: Bool = false) {
        if isSessionRunning && currentMode == interactionMode {
            clearCurrentObjects()
            return
        }
        
        if isSessionRunning {
            arView.session.pause()
            isSessionRunning = false
        }
        
        currentMode = interactionMode
        clearAllObjects()
        
        createConfiguration()
        
        if showOverlay {
            showCoachOverlay()
        }
        
        isSessionRunning = true
    }
    
    func stop() {
        clearCurrentObjects()
    }
    
    func forceStop() {
        if isSessionRunning {
            arView.session.pause()
            isSessionRunning = false
        }
        clearAllObjects()
        currentMode = nil
    }
    
    private func clearAllObjects() {
        arView.scene.anchors.removeAll()
        measurementPoints.removeAll()
        distancePublisher.send(nil)
    }
    
    private func clearCurrentObjects() {
        if interactionMode == .measuring {
            removeMeasurementPoints()
        } else {
            let nonMeasurementAnchors = arView.scene.anchors.filter { $0.name != "measurementPointAnchor" }
            for anchor in nonMeasurementAnchors {
                arView.scene.removeAnchor(anchor)
            }
        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) { }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("ARSession falhou: \(error.localizedDescription)")
        isSessionRunning = false
        currentMode = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let currentMode = self.currentMode {
                self.interactionMode = currentMode
                self.start(showOverlay: false)
            }
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal, .limited:
            break
        case .notAvailable:
            isSessionRunning = false
            currentMode = nil
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if interactionMode == .placingObjects {
            guard let object = arView.scene.anchors.first?.children.first else {
                return
            }

            let cameraTransform = arView.cameraTransform
            let objectPosition = object.position(relativeTo: nil)
            let calculatedDistance = simd_distance(cameraTransform.translation, objectPosition)
            
            distancePublisher.send(calculatedDistance)
        }
    }
    
    func addMeasurementPoint() {
        let screenCenter = arView.center
        
        guard let result = arView.raycast(from: screenCenter, allowing: .estimatedPlane, alignment: .any).first else {
            return
        }
        
        let worldPosition = result.worldTransform.columns.3.xyz
        
        let sphereMesh = MeshResource.generateSphere(radius: 0.003)
        let material = SimpleMaterial(color: .white, isMetallic: false)
        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [material])
        
        let anchor = AnchorEntity(world: worldPosition)
        anchor.name = "measurementPointAnchor"
        anchor.addChild(sphereEntity)
        arView.scene.addAnchor(anchor)
        
        measurementPoints.append(worldPosition)
        
        if measurementPoints.count == 2 {
            let pointA = measurementPoints[0]
            let pointB = measurementPoints[1]
            
            let calculatedDistance = distance(pointA, pointB)
            
            distancePublisher.send(calculatedDistance)
        } else {
            distancePublisher.send(nil)
        }
    }
    
    func removeMeasurementPoints() {
        let measurementAnchors = arView.scene.anchors.filter { $0.name == "measurementPointAnchor" }
        
        for anchor in measurementAnchors {
            arView.scene.removeAnchor(anchor)
        }
        
        measurementPoints.removeAll()
        distancePublisher.send(nil)
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tapGesture)
    }
    
    private func createConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        
        guard ARWorldTrackingConfiguration.isSupported else {
            return
        }
        
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        DispatchQueue.main.async {
            self.arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    private func showCoachOverlay() {
        arView.subviews.compactMap { $0 as? ARCoachingOverlayView }.forEach { $0.removeFromSuperview() }
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)
    }

    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard interactionMode == .placingObjects else {
            return
        }
        
        let location = recognizer.location(in: arView)
        
        if let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
            let nonMeasurementAnchors = arView.scene.anchors.filter { $0.name != "measurementPointAnchor" }
            for anchor in nonMeasurementAnchors {
                arView.scene.removeAnchor(anchor)
            }
            
            let newAnchor = AnchorEntity(world: result.worldTransform)
            let box = ModelEntity(mesh: .generateCylinder(height: 0.2, radius: 0.10), materials: [SimpleMaterial(color: .white.withAlphaComponent(0.6), isMetallic: false)])
            newAnchor.addChild(box)
            arView.scene.addAnchor(newAnchor)
        }
    }
}

fileprivate extension SIMD4 where Scalar == Float {
    var xyz: SIMD3<Float> {
        return SIMD3<Float>(x, y, z)
    }
}
