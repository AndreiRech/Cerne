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

class ARService: NSObject, ARServiceProtocol, ARSessionDelegate, ObservableObject {
    let arView: ARView
    let distancePublisher = PassthroughSubject<Float, Never>()
    
    override init() {
        self.arView = ARView(frame: .zero)
        super.init()
        
        self.arView.session.delegate = self
        setupGestures()
    }
    
    func start(showOverlay: Bool = false) {
        createConfiguration()
        if showOverlay {
            showCoachOverlay()
        }
        placeInitialObject()
    }
    
    func stop() {
        arView.session.pause()
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let object = arView.scene.anchors.first?.children.first else { return }

        let cameraTransform = arView.cameraTransform
        let objectPosition = object.position(relativeTo: nil)
        let calculatedDistance = simd_distance(cameraTransform.translation, objectPosition)
        
        distancePublisher.send(calculatedDistance)
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tapGesture)
    }
    
    private func createConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
    }
    
    private func showCoachOverlay() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)
    }
    
    private func placeInitialObject() {
        let anchor = AnchorEntity(plane: .horizontal)
        let box = ModelEntity(mesh: .generateCylinder(height: 0.3, radius: 0.10), materials: [SimpleMaterial(color: .white.withAlphaComponent(0.6), isMetallic: false)])
        box.generateCollisionShapes(recursive: false)
        anchor.addChild(box)
        arView.scene.addAnchor(anchor)
    }
    
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: arView)
        
        if let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
            arView.scene.anchors.removeAll()
            
            let newAnchor = AnchorEntity(world: result.worldTransform)
            let box = ModelEntity(mesh: .generateCylinder(height: 0.3, radius: 0.15), materials: [SimpleMaterial(color: .white.withAlphaComponent(0.6), isMetallic: false)])
            newAnchor.addChild(box)
            arView.scene.addAnchor(newAnchor)
        }
    }
}
