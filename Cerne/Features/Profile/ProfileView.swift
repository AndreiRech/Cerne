//
//  ProfileView.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 25/09/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var router: Router
    
    @State var viewModel: ProfileViewModelProtocol
    @State private var isShowingDeleteAlert = false
    
    var body: some View {
        NavigationStack(path: $router.path) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Sua trajetória nos inspira!")
                                .foregroundStyle(.primitivePrimary)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            if viewModel.userPins.count == 0 {
                                EmptyComponent(bgColor: .backgroundSecondary, cornerColor: .primitivePrimary, subtitle: "Nenhuma árvore registrada", description: "Comece a mapear árvores para acompanhar o CO₂ já capturado pelas suas contribuições", buttonTitle: "Registrar primeira árvore", buttonAction: { router.path.append(Route.registerTree) })
                            } else {
                                HStack(alignment: .center, spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(String(viewModel.userPins.count))
                                            .foregroundStyle(.primitivePrimary)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                        
                                        Text("árvores\nregistradas")
                                            .foregroundStyle(.primitivePrimary)
                                            .font(.body)
                                            .fontWeight(.regular)
                                        
                                    }
                                    .padding(20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 26)
                                            .foregroundStyle(.CTA)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 26)
                                                    .stroke(.primitivePrimary, lineWidth: 1)
                                            )
                                    )
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(viewModel.totalCO2User())
                                            .foregroundStyle(.primitivePrimary)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                        
                                        Text("quilos de CO²\nsequestrados ")
                                            .foregroundStyle(.primitivePrimary)
                                            .font(.body)
                                            .fontWeight(.regular)
                                    }
                                    .padding(20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 26)
                                            .foregroundStyle(.backgroundPrimary)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 26)
                                                    .stroke(.primitivePrimary, lineWidth: 1)
                                            )
                                    )
                                }
                                
                                Text("Reunimos aqui várias informações sobre sua trajetória dentro do Cerne. Fique a vontade para explorar")
                                    .foregroundStyle(.primitivePrimary)
                                    .font(.footnote)
                                    .fontWeight(.regular)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .center, spacing: 0) {
                                Text("Minha pegada de carbono")
                                    .foregroundStyle(.primitivePrimary)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                if viewModel.footprint != nil {
                                    Button {
                                        router.path.append(Route.footprint)
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                            .foregroundStyle(.CTA)
                                            .font(.body)
                                            .fontWeight(.regular)
                                    }
                                }
                            }
                            
                            if viewModel.footprint == nil {
                                EmptyComponent(bgColor: .backgroundPrimary, cornerColor: .primitivePrimary, subtitle: "Cálculo ainda não realizado", description: "Complete o questionário para calcular sua pegada de carbono e descobrir seu impacto no planeta", buttonTitle: "Calcular pegada de carbono", buttonAction: { router.path.append(Route.footprint) })
                            } else {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .center, spacing: 8) {
                                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                                            .foregroundStyle(.primitivePrimary)
                                            .font(.body)
                                            .fontWeight(.semibold)
                                        
                                        HStack(alignment: .bottom, spacing: 8) {
                                            Text(viewModel.footprint ?? "")
                                                .foregroundStyle(.primitivePrimary)
                                                .font(.largeTitle)
                                                .fontWeight(.bold)
                                            
                                            Text("de CO² por ano")
                                                .foregroundStyle(.primitivePrimary)
                                                .font(.title3)
                                                .fontWeight(.regular)
                                        }
                                    }
                                    
                                    Text("As decisões e hábitos do seu cotidiano estão diretamente associados ao seu impacto no planeta")
                                        .foregroundStyle(.primitivePrimary)
                                        .font(.footnote)
                                        .fontWeight(.regular)
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 26)
                                        .foregroundStyle(.backgroundPrimary)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 26)
                                                .stroke(.primitivePrimary, lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Meu progresso anual")
                                .foregroundStyle(.primitivePrimary)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            
                        }
                        
                        Button {
                            isShowingDeleteAlert = true
                        } label: {
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "trash")
                                
                                Text("Deletar conta")
                            }
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundStyle(.CTA)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 1000)
                                    .foregroundStyle(.fillsTertiary)
                            )
                        }
                    }
                    .padding(16)
                }
                .background(.backgroundPrimary)
                .alert("Deletar conta definitivamente", isPresented: $isShowingDeleteAlert) {
                    Button("Cancelar", role: .cancel) { }
                    Button("Deletar", role: .destructive) {
                        Task {
                            await viewModel.deleteAccount()
                            router.path.append(Route.onBoarding)
                        }
                    }
                } message: {
                    Text("Essa ação não pode ser desfeita. Seus dados e conquistas serão removidos de forma definitiva.")
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .footprint:
                        FootprintView(
                            viewModel: FootprintViewModel(
                                footprintService: FootprintService(),
                                userService: UserService()
                            )
                        )
                        .toolbar(.hidden, for: .tabBar)
                        
                    case .registerTree:
                        PhotoView(
                            viewModel: PhotoViewModel(
                                cameraService: CameraService(),
                                treeAPIService: TreeAPIService(),
                                userDefaultService: UserDefaultService()
                            )
                        )
                        .toolbar(.hidden, for: .tabBar)
                        .navigationBarBackButtonHidden(true)
                        
                    case .onBoarding:
                        OnboardingView(
                            viewModel: OnboardingViewModel(
                                userDefaultService: UserDefaultService(),
                                userService: UserService()
                            )
                        )
                            .toolbar(.hidden, for: .tabBar)
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchUserPins()
        }
    }
}
