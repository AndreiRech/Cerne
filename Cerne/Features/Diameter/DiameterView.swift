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
        ZStack {
            
            ARSceneView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            if viewModel.showInfo {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                InstructionComponent(
                    imageName: "ruler",
                    title: "Na altura do peito, use os pontos para registrar o diâmetro do tronco",
                    buttonText: "Medir diâmetro") {
                        viewModel.showInfo = false
                    }
            } else {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                    
                    VStack (spacing: 15) {
                        Spacer()
                        
                        if viewModel.showAddPointHint {
                            
                            Text("Adicionar um ponto")
                                .font(.body)
                                .fontWeight(.medium)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .transition(.opacity.animation(.easeInOut))
                            
                        }
                        
                        if viewModel.result == nil || viewModel.result == 0 {
                            Button {
                                viewModel.triggerPointPlacement()
                            } label: {
                                if #available(iOS 26.0, *) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 24, weight: .bold))
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(.black)
                                        .glassEffect()
                                } else {
                                    Image(systemName: "plus")
                                        .font(.system(size: 24, weight: .bold))
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(.black)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Capsule())
                                }
                                
                            }
                        } else {
                            Button {
                                viewModel.shouldNavigate = true
                            } label: {
                                if #available(iOS 26.0, *) {
                                    Text("Continuar")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding()
                                        .glassEffect()
                                } else {
                                    Text("Continuar")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .padding(.bottom, 50)
                    .onAppear {
                        viewModel.showAddPointHint = true
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                            withAnimation {
                                viewModel.showAddPointHint = false
                            }
                        }
                    }
                }
            }
        }
        .onAppear { viewModel.runSession() }
        .onDisappear { viewModel.pauseSession() }
        
        .toolbar {
            ToolbarItem {
                Button {
                    if viewModel.result != nil && viewModel.result ?? 0 > 0 {
                        viewModel.resetNodes()
                    } else {
                        viewModel.showInfo.toggle()
                    }
                } label: {
                    if viewModel.showInfo {
                        Image(systemName: "xmark")
                    } else if viewModel.result != nil && viewModel.result ?? 0 > 0 {
                        Image(systemName: "trash")
                    } else {
                        Image(systemName: "info.circle")
                    }
                }
                .tint(.primary)
            }
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigate) {
            DistanceView(
                viewModel: DistanceViewModel(
                    arService: ARService(),
                    userDefaultService: UserDefaultService(),
                    userHeight: 1.85,
                    measuredDiameter: Double(viewModel.result ?? 0.0),
                    treeImage: viewModel.treeImage
                )
            )
            .navigationBarHidden(false)
        }
    }
}

struct ARSceneView: UIViewRepresentable {
    @ObservedObject var viewModel: DiameterViewModel
    
    func makeUIView(context: Context) -> ARSCNView {
        return viewModel.sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if viewModel.placePointTrigger {
            viewModel.addPointAtCenter(in: uiView)
            DispatchQueue.main.async {
                viewModel.placePointTrigger = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(viewModel: viewModel) }
    
    class Coordinator: NSObject {
        let viewModel: DiameterViewModelProtocol
        
        init(viewModel: DiameterViewModelProtocol) {
            self.viewModel = viewModel
        }
    }
}
