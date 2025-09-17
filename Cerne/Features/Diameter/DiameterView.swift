//
//  DiameterView.swift
//  Cerne
//
//  Created by Maria Santellano on 09/09/25.
//

import SwiftUI
import ARKit

/// A tela principal para medir o diâmetro de um objeto usando Realidade Aumentada.
/// Ela gerencia a exibição da cena AR e a interface do usuário para interação.
struct DiameterView: View {
    /// O ViewModel que gerencia o estado e a lógica da medição de diâmetro.
    @State var viewModel: DiameterViewModel
    
    var body: some View {
        ZStack {
            // MARK: - Cena de Realidade Aumentada
            // Renderiza a visão da câmera com os elementos de AR. É a camada de fundo.
            ARSceneView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            // MARK: - Tela de Instruções
            // Exibe um overlay com instruções antes do início da medição.
            if viewModel.showInfo {
                // Fundo semitransparente para focar nas instruções
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                // Componente reutilizável que mostra as instruções e um botão para começar.
                InstructionComponent(
                    imageName: "ruler",
                    title: "Na altura do peito, use os pontos para registrar o diâmetro do tronco",
                    buttonText: "Medir diâmetro") {
                        // Ação do botão: esconde a tela de instruções para iniciar a medição.
                        viewModel.showInfo = false
                    }
            } else {
                // MARK: - Interface de Medição
                ZStack {
                    // Ponto central branco que funciona como uma mira para o usuário.
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                    
                    // Contêiner para os botões e dicas na parte inferior da tela.
                    VStack (spacing: 15) {
                        Spacer()
                        
                        // Exibe uma dica temporária para o usuário adicionar o primeiro ponto.
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
                        
                        // MARK: - Botão de Ação Principal
                        // O botão muda de função dependendo se a medição foi concluída.
                        if viewModel.result == nil || viewModel.result == 0 {
                            // Botão para adicionar pontos de medição.
                            Button(action: {
                                // Aciona a lógica para adicionar um ponto no centro da tela.
                                viewModel.triggerPointPlacement()
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.black)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        } else {
                            // Botão para prosseguir para a próxima tela após a medição.
                            Button(action: {
                                // Ativa a flag de navegação.
                                viewModel.shouldNavigate = true
                            }) {
                                Text("Continuar")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding(.bottom, 50)
                    .onAppear {
                        // Quando a interface de medição aparece, exibe a dica por 3 segundos.
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
        // MARK: - Gerenciamento do Ciclo de Vida da View
        .onAppear { viewModel.runSession() }       // Inicia a sessão AR quando a view aparece.
        .onDisappear { viewModel.pauseSession() }   // Pausa a sessão AR quando a view desaparece.
        
        // MARK: - Barra de Ferramentas (Toolbar)
        .toolbar {
            ToolbarItem {
                Button {
                    // Ação do botão varia com o estado atual.
                    if viewModel.result != nil && viewModel.result ?? 0 > 0 {
                        // Se já há um resultado, o botão serve para resetar a medição.
                        viewModel.resetNodes()
                    } else {
                        // Caso contrário, ele alterna a exibição da tela de informações.
                        viewModel.showInfo.toggle()
                    }
                } label: {
                    // O ícone do botão também muda de acordo com o contexto.
                    if viewModel.showInfo {
                        Image(systemName: "xmark") // Ícone 'X' para fechar as instruções.
                    } else if viewModel.result != nil && viewModel.result ?? 0 > 0 {
                        Image(systemName: "trash") // Ícone de lixeira para resetar.
                    } else {
                        Image(systemName: "info.circle") // Ícone de informação para abrir as instruções.
                    }
                }
                .tint(.primary)
            }
        }
        // MARK: - Navegação
        // Define o destino da navegação quando 'shouldNavigate' se torna verdadeiro.
        .navigationDestination(isPresented: $viewModel.shouldNavigate) {
            // Navega para a 'DistanceView', passando os dados da medição atual.
            DistanceView(
                viewModel: DistanceViewModel(
                    arService: ARService(),
                    userHeight: 1.85,
                    measuredDiameter: Double(viewModel.result ?? 0.0),
                    treeImage: viewModel.treeImage
                )
            )
            .navigationBarHidden(false)
        }
    }
}

// MARK: - Wrapper de ARSCNView para SwiftUI
/// `ARSceneView` é uma estrutura que conforma com `UIViewRepresentable` para
/// integrar uma `ARSCNView` (do UIKit) em uma hierarquia de views do SwiftUI.
struct ARSceneView: UIViewRepresentable {
    /// O ViewModel que controla a cena AR. Usa `@ObservedObject` para reagir a mudanças.
    @ObservedObject var viewModel: DiameterViewModel
    
    /// Cria e configura a `ARSCNView` inicial.
    func makeUIView(context: Context) -> ARSCNView {
        // Retorna a instância da sceneView gerenciada pelo ViewModel.
        return viewModel.sceneView
    }
    
    /// Atualiza a `ARSCNView` quando o estado no SwiftUI muda.
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Verifica se o gatilho para adicionar um ponto foi ativado.
        if viewModel.placePointTrigger {
            // Chama a função do ViewModel para adicionar um ponto 3D no centro da tela.
            viewModel.addPointAtCenter(in: uiView)
            // Reseta o gatilho para evitar que o ponto seja adicionado múltiplas vezes.
            DispatchQueue.main.async {
                viewModel.placePointTrigger = false
            }
        }
    }
    
    /// Cria um `Coordinator` para lidar com eventos ou delegações da `ARSCNView`.
    func makeCoordinator() -> Coordinator { Coordinator(viewModel: viewModel) }
    
    /// Classe `Coordinator` para mediar a comunicação entre a `UIView` e o SwiftUI.
    /// (Neste caso, sua função é mínima, mas é parte do padrão `UIViewRepresentable`).
    class Coordinator: NSObject {
        let viewModel: DiameterViewModelProtocol
        
        init(viewModel: DiameterViewModelProtocol) {
            self.viewModel = viewModel
        }
    }
}
