//
//  CameraPreview.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    let service: CameraServiceProtocol
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        service.previewLayer.frame = view.bounds
        view.layer.addSublayer(service.previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            self.service.previewLayer.frame = uiView.bounds
        }
    }
}
