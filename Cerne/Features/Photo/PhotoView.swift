//
//  PhotoView.swift
//  Cerne
//
//  Created by Andrei Rech on 09/09/25.
//

import SwiftUI

struct PhotoView: View {
    @EnvironmentObject var router: Router
    @State var viewModel: PhotoViewModelProtocol
    
    var body: some View {
        ZStack {
            if let capturedImage = viewModel.capturedImage {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    if viewModel.isIdentifying {
                        if viewModel.isLoading {
                            Spacer()
                            
                            ProgressView()
                                .scaleEffect(1.5)
                                .frame(width: 60, height: 60)
                                .glassEffect()
                            
                            Spacer()
                        } else {
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 0) {
                                HStack(spacing: 10) {
                                    Image(.treeIcon)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.CTA)
                                    
                                    Text(viewModel.identifiedTree?.bestMatch ?? "")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primitivePrimary)
                                }
                                .foregroundColor(.white)
                                
                                Text("Espécie da árvore identificada")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(20)
                            .glassEffect(in: .rect(cornerRadius: 24))
                            
                            Spacer()
                            
                            Button {
                                viewModel.shouldNavigate.toggle()
                            } label: {
                                Text("Continuar")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                    .glassEffect()
                            }
                            .padding(.bottom, 100)
                            .navigationDestination(isPresented: $viewModel.shouldNavigate) {
                                DiameterView(
                                    viewModel: DiameterViewModel(
                                        treeImage: capturedImage,
                                        userDefaultService: UserDefaultService(),
                                        treeSpecies: viewModel.identifiedTree?.bestMatch ?? ""
                                    )
                                )
                                .navigationBarHidden(false)
                            }
                        }
                    } else {
                        Spacer()
                        
                        Button {
                            Task {
                                await viewModel.identifyTree(image: capturedImage)
                            }
                        } label: {
                            Text("Identificar")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .glassEffect()
                        }
                        .padding(.bottom, 100)
                    }
                }
                .ignoresSafeArea()
            } else {
                CameraPreview(service: viewModel.cameraService)
                    .ignoresSafeArea()
                
                if viewModel.showInfo {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    InstructionComponent(
                        imageName: "camera",
                        title: "Tire uma foto capturando o máximo da árvore para identificarmos a espécie",
                        buttonText: "Registrar agora",
                        onTap: {
                            viewModel.showInfo.toggle()
                            viewModel.isMeasuring.toggle()
                        })
                } else {
                    VStack {
                        Spacer()
                        
                        Button {
                            viewModel.capturePhoto()
                            viewModel.isMeasuring.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 70, height: 70)
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .frame(width: 80, height: 80)
                            }
                        }
                        .padding(.bottom, 85)
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    .alert("Ainda não conseguimos reconhecer", isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) {
                viewModel.isMeasuring = true
                viewModel.shouldNavigate = false
                viewModel.retakePhoto()
            }
        } message: {
            Text("Pode ser um detalhe da foto ou da iluminação. Refaça o registro para que possamos analisar de novo.")
        }
        .navigationBarHidden(false)
        .toolbar {
            ToolbarItem {
                Button("", systemImage: viewModel.showInfo ? "xmark" : viewModel.isMeasuring ? "info" : "xmark") {
                    if viewModel.showInfo {
                        viewModel.showInfo = false
                        viewModel.isMeasuring = true
                    } else if viewModel.isMeasuring {
                        viewModel.showInfo = true
                        viewModel.isMeasuring = false
                    } else {
                        viewModel.showInfo = false
                        viewModel.isMeasuring = true
                        viewModel.retakePhoto()
                    }
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button("", systemImage: "chevron.backward") {
                    router.popToRoot()
                }
            }
        }
    }
}

