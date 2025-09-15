//
//  HeightView.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import SwiftUI

struct HeightView: View {
    @State var viewModel: HeightViewModelProtocol
    @Environment(\.modelContext) private var modelContext

    
    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreview(service: viewModel.cameraService)
                    .ignoresSafeArea()
                
                Circle()
                    .stroke(Color.white.opacity(0.8), lineWidth: 2)
                    .frame(width: 30, height: 30)
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Text("Ângulo Atual")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Altura Estimada da Árvore")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top)

                        Text(String(format: "%.2f metros", viewModel.estimatedHeight))
                            .font(.system(size: 50, weight: .bold, design: .monospaced))
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(20)
                    .padding()
                }
                VStack {
                    Spacer()
                    
                    Button(action: {
                        viewModel.finishMeasurement(estimatedHeight: viewModel.estimatedHeight)
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
                            TreeReviewView(
                                viewModel: TreeReviewViewModel(
                                    cameraService: CameraService(),
                                    scannedTreeService: ScannedTreeService(modelContext: modelContext),
                                    treeAPIService: TreeAPIService(),
                                    pinService: PinService(modelContext: modelContext),
                                    measuredDiameter: viewModel.measuredDiameter,
                                    treeImage: viewModel.treeImage,
                                    estimatedHeight: viewModel.estimatedHeight,
                                    pinLatitude: 10.2,
                                    pinLongitude: 11.4
                                )
                            )
                            .navigationBarHidden(true)
                        }
                }
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    }
}
