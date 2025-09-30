//
//  DiameterView.swift
//  Cerne
//
//  Created by Maria Santellano on 09/09/25.
//

import SwiftUI
import RealityKit

struct DiameterView: View {
    @State var viewModel: any DiameterViewModelProtocol
    
    var body: some View {
        ZStack {
            ARPreview(service: viewModel.arService)
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
                    
                    if let result = viewModel.result, result > 0 {
                    } else {
                        GeometryReader { geometry in
                            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            let measurementAnchors = viewModel.arService.arView.scene.anchors.filter { $0.name == "measurementPointAnchor" }
                            if measurementAnchors.count == 1, let firstPointAnchor = measurementAnchors.first,
                               let firstPoint = viewModel.arService.arView.project(firstPointAnchor.position) {
                                Path { path in
                                    path.move(to: firstPoint)
                                    path.addLine(to: center)
                                }
                                .stroke(Color.white, lineWidth: 2)
                            }
                        }
                    }
                    
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
                        
                        if let result = viewModel.result, result > 0 {
                            Text(String(format: "%.2f m", result))
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
                                viewModel.placePointButtonTapped()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.black)
                                    .glassEffect()
                            }
                        } else {
                            Button {
                                viewModel.shouldNavigate = true
                            } label: {
                                Text("Continuar")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding()
                                    .glassEffect()
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
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
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
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: Binding(get: { viewModel.shouldNavigate }, set: { viewModel.shouldNavigate = $0 })) {
            DistanceView(
                viewModel: DistanceViewModel(
                    userDefaultService: UserDefaultService(),
                    userHeight: 1.85,
                    measuredDiameter: Double(viewModel.result ?? 0.0),
                    treeImage: viewModel.treeImage,
                    treeSpecies: viewModel.treeSpecies
                )
            )
            .navigationBarHidden(false)
        }
    }
}

