//
//  PhotoView.swift
//  Cerne
//
//  Created by Andrei Rech on 09/09/25.
//

import SwiftUI

struct PhotoView: View {
    @State var viewModel: PhotoViewModelProtocol
    
    var body: some View {

        NavigationStack {
            ZStack {
                if let capturedImage = viewModel.capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    
                    if viewModel.isLoading {
                        ZStack {
                            Color.black.opacity(0.5).ignoresSafeArea()
                            ProgressView("Identificando...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .foregroundColor(.white)
                        }
                    } else {
                        Text(viewModel.identifiedTree?.bestMatch ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                    }
                } else {
                    CameraPreview(service: viewModel.cameraService)
                        .ignoresSafeArea()
                }
                
                    VStack {
                        Spacer()
                        
                        if let capturedImage = viewModel.capturedImage {
                            HStack {
                                Button("Refazer") {
                                    viewModel.retakePhoto()
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                
                                Spacer()
                                
                                Button(action: {
                                    Task {
                                        await viewModel.identifyTree(image: capturedImage)
                                    }
                                }) {
                                    Text("Identificar")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(15)
                                }
                                .navigationDestination(isPresented: $viewModel.shouldNavigate) {
                                        DiameterView(
                                            viewModel: DiameterViewModel(
                                                cameraService: CameraService(),
                                                treeImage: capturedImage
                                            )
                                        )
                                        .navigationBarHidden(false)
                                    }
                            }
                            .padding(.horizontal, 30)
                            .frame(height: 100)
                        } else {
                            HStack {
                                Spacer()
                                Button(action: viewModel.capturePhoto) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 70, height: 70)
                                        Circle()
                                            .stroke(Color.white, lineWidth: 4)
                                            .frame(width: 80, height: 80)
                                    }
                                }
                                Spacer()
                            }
                            .frame(height: 100)
                        }
                    }
                .padding(.bottom, 30)
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
        .alert("Erro", isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "Ocorreu um erro desconhecido.")
        }
    }
}

