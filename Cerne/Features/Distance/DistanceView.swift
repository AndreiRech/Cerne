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
                    imageName: "scale.3d",
                    title: "Aponte a câmera para a base do tronco e posicione o objeto 3D",
                    buttonText: "Fixar 3D na base",
                    onTap: {
                        viewModel.showInfo.toggle()
                        viewModel.isMeasuring.toggle()
                    })
            } else {
                VStack {
                    Spacer()
                    
                    Button {
                        viewModel.shouldNavigate = true
                        viewModel.getUserLocation()
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
                    .padding(.bottom, 100)
                }
                .ignoresSafeArea()
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
        .navigationDestination(isPresented: $viewModel.shouldNavigate) {
            HeightView(
                viewModel: HeightViewModel(
                    cameraService: CameraService(),
                    motionService: MotionService(),
                    scannedTreeService: ScannedTreeService(),
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
