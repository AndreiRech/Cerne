//
//  DiameterView.swift
//  Cerne
//
//  Created by Maria Santellano on 09/09/25.
//

import SwiftUI
import ARKit

struct DiameterView: View {
    @State var viewModel: DiameterViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                ARSceneView(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Button(action: {
                        viewModel.finishMeasurement()
                        viewModel.shouldNavigate = true
                    }) {
                        Text("Concluir Medida")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 30)
                    .frame(height: 100)
                    .navigationDestination(isPresented: $viewModel.shouldNavigate) {
                            HeightView(
                                viewModel: HeightViewModel(
                                    cameraService: CameraService(),
                                    motionService: MotionService(),
                                    userHeight: 1.85,
                                    distanceToTree: 5,
                                    measuredDiameter: viewModel.result ?? 0.0
                                )
                            )
                            .navigationBarHidden(true)
                        }
                    
                }
            }
            .navigationTitle("Medir Diâmetro")
        }
    }
}


// MARK: - View
struct ARSceneView: UIViewRepresentable {
    @ObservedObject var viewModel: DiameterViewModel
    
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        sceneView.delegate = viewModel
        sceneView.debugOptions = [.showFeaturePoints] //esse da p tirar
        sceneView.autoenablesDefaultLighting = true
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = []
        sceneView.session.run(configuration)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(viewModel: viewModel) }
    
    class Coordinator: NSObject {
        let viewModel: DiameterViewModelProtocol
        
        init(viewModel: DiameterViewModelProtocol) {
            self.viewModel = viewModel
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let sceneView = gesture.view as? ARSCNView else { return }
            let location = gesture.location(in: sceneView)
            viewModel.handleTap(at: location, in: sceneView)
        }
    }
}
