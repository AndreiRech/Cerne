//
//  ARPreview.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import SwiftUI
import RealityKit

struct ARPreview: UIViewRepresentable {
    let service: ARServiceProtocol
    
    func makeUIView(context: Context) -> ARView {
        return service.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        uiView.session.pause()
    }
}
