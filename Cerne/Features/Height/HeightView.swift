import SwiftUI

struct HeightView: View {
    @State var viewModel: HeightViewModelProtocol
    
    var body: some View {
        ZStack {
            CameraPreview(service: viewModel.cameraService)
                .ignoresSafeArea()
            
            if viewModel.showInfo {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                InstructionComponent(
                    imageName: viewModel.firstInstruction ? "figure.walk" : "chevron.up.2",
                    title: viewModel.firstInstruction ? "Para medirmos a altura, dê alguns passos para longe da árvore até o topo aparecer na tela" : "Mire no ponto mais alto da árvore e adicione o ponto para registrar a altura",
                    buttonText: viewModel.firstInstruction ? "Encontrar distância ideal" : "Capturar o topo",
                    onTap: {
                        if viewModel.firstInstruction {
                            viewModel.firstInstruction.toggle()
                        } else {
                            viewModel.showInfo.toggle()
                            viewModel.isMeasuring.toggle()
                            viewModel.firstInstruction.toggle()
                        }
                    })
            } else if !viewModel.shouldNavigate {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                    
                    VStack {
                        Spacer()
                        
                        if #available(iOS 26.0, *) {
                            HStack(spacing: 10) {
                                Image(systemName: "tree")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.CTA)
                                
                                Text(String(format: "%.2f m de altura", viewModel.isMeasuring ? viewModel.estimatedHeight : viewModel.finalHeight))
                                    .font(.body)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(20)
                            .glassEffect()
                            .offset(y: 120)
                        } else {
                            HStack(spacing: 10) {
                                Image(systemName: "tree")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.CTA)
                                
                                Text(String(format: "%.2f m de altura", viewModel.isMeasuring ? viewModel.estimatedHeight : viewModel.finalHeight))
                                    .font(.body)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(20)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .offset(y: 120)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.isMeasuring ? viewModel.saveHeight() : viewModel.shouldNavigate.toggle()
                        } label: {
                            if #available(iOS 26.0, *) {
                                Text(viewModel.isMeasuring ? "Posicionar" : "Finalizar")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                    .glassEffect()
                            } else {
                                Text(viewModel.isMeasuring ? "Posicionar" : "Finalizar")
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
                }
                .ignoresSafeArea()
            }
            
            if viewModel.shouldNavigate {
                TreeReviewView(
                    viewModel: TreeReviewViewModel(
                        cameraService: CameraService(),
                        scannedTreeService: ScannedTreeService(),
                        treeAPIService: TreeAPIService(),
                        pinService: PinService(),
                        measuredDiameter: viewModel.measuredDiameter,
                        treeImage: viewModel.treeImage,
                        estimatedHeight: viewModel.estimatedHeight,
                        pinLatitude: viewModel.userLatitude,
                        pinLongitude: viewModel.userLongitude
                    )
                )
                .presentationDetents([.height(500)])
                .presentationDragIndicator(.hidden)
                .padding(.horizontal, 16)
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
        .navigationBarHidden(false)
        .toolbar {
            if !viewModel.shouldNavigate {
                ToolbarItem {
                    Button("", systemImage: viewModel.showInfo ? "xmark" : viewModel.isMeasuring ? "info" : "trash") {
                        if viewModel.showInfo {
                            viewModel.showInfo = false
                            viewModel.isMeasuring = true
                        } else if viewModel.isMeasuring {
                            viewModel.showInfo = true
                            viewModel.isMeasuring = false
                        } else {
                            viewModel.showInfo = false
                            viewModel.isMeasuring = true
                        }
                    }
                }
            }
        }
        .toolbar(viewModel.shouldNavigate ? .visible : .hidden, for: .navigationBar)
    }
}
