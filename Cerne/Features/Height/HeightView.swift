import SwiftUI

struct HeightView: View {
    @State var viewModel: HeightViewModelProtocol
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            CameraPreview(service: viewModel.cameraService)
                .ignoresSafeArea()
            
            if viewModel.showInfo {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                InstructionComponent(
                    imageName: "chevron.up.2",
                    title: "Mire no ponto mais alto da árvore e adicione o ponto para registrar a altura",
                    buttonText: "Capturar o topo",
                    onTap: {
                        viewModel.showInfo.toggle()
                        viewModel.isMeasuring.toggle()
                })
            } else {
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
                                    .foregroundStyle(.yellow)
                                
                                Text(String(format: "%.2f m de altura", viewModel.isMeasuring ? viewModel.estimatedHeight : viewModel.finalHeight))
                                    .font(.body)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .glassEffect()
                            .offset(y: 120)
                        } else {
                            HStack(spacing: 10) {
                                Image(systemName: "tree")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.yellow)
                                
                                Text(String(format: "%.2f m de altura", viewModel.isMeasuring ? viewModel.estimatedHeight : viewModel.finalHeight))
                                    .font(.body)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .offset(y: 120)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.isMeasuring ? viewModel.saveHeight() : dismiss()
                        } label: {
                            if #available(iOS 26.0, *) {
                                Text(viewModel.isMeasuring ? "Posicionar" : "Finalizar")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 15)
                                    .glassEffect()
                            } else {
                                Text(viewModel.isMeasuring ? "Posicionar" : "Finalizar")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 15)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.bottom, 50)
                    }
                }
                .ignoresSafeArea()
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    }
}
