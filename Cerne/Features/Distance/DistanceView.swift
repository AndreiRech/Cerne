//
//  DistanceView.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import SwiftUI

struct DistanceView: View {
    @State var viewModel: any DistanceViewModelProtocol
    
    var body: some View {
        ZStack {
            ARPreview(service: viewModel.arService)
                .edgesIgnoringSafeArea(.all)
            
            if viewModel.showInfo {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                InstructionComponent(
                    imageName: "graph.3d",
                    title: "Aponte a câmera para a base do tronco e posicione o objeto 3D",
                    buttonText: "Fixar 3D na base",
                    onTap: {
                        viewModel.showInfo.toggle()
                        viewModel.isMeasuring.toggle()
                    })
            } else {
                VStack (spacing: 15) {
                    Spacer()
                    
                    if viewModel.showAddPointHint {
                        Text("Posicione o objeto")
                            .font(.body)
                            .fontWeight(.medium)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .transition(.opacity.animation(.easeInOut))
                    }
                    
                    Button {
                        viewModel.getUserLocation {
                            viewModel.shouldNavigate = true
                        }
                    } label: {
                        if #available(iOS 26.0, *) {
                            Text("Continuar")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .glassEffect()
                        } else {
                            Text("Continuar")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                        }
                    }
                    .disabled(viewModel.distance <= 0)
                    .padding(.bottom, 100)
                }
                .ignoresSafeArea()
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
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .navigationDestination(isPresented: $viewModel.shouldNavigate) {
            HeightView(
                viewModel: HeightViewModel(
                    cameraService: CameraService(),
                    motionService: MotionService(),
                    scannedTreeService: ScannedTreeService(),
                    userDefaultService: UserDefaultService(),
                    userHeight: 1.80,
                    distanceToTree: viewModel.distance,
                    measuredDiameter: viewModel.measuredDiameter,
                    treeImage: viewModel.treeImage,
                    userLatitude: viewModel.userLatitude,
                    userLongitude: viewModel.userLongitude
                )
            )
            .navigationBarHidden(false)
        }
        .toolbar {
            ToolbarItem {
                Button("", systemImage: viewModel.showInfo ? "xmark" : "info") {
                    if viewModel.showInfo {
                        viewModel.showInfo = false
                        viewModel.isMeasuring = true
                    } else {
                        viewModel.showInfo = true
                        viewModel.isMeasuring = false
                    }
                }
            }
        }
    }
}
