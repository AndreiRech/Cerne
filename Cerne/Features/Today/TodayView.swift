//
//  TodayView.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import SwiftUI

struct TodayView: View {
    @State var viewModel: any TodayViewModelProtocol
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                NavigationStack(path: $router.path) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Meu impacto no planeta")
                                    .font(.system(.title3, weight: .semibold))
                                
                                if viewModel.monthlyObjective == 0 {
                                    EmptyComponent(
                                        bgColor: .backgroundSecondary,
                                        cornerColor: .backgroundSecondary,
                                        icon: "leaf.arrow.trianglehead.clockwise",
                                        title: "Sem registros por enquanto",
                                        subtitle: "Cálculo ainda não realizado",
                                        description: "Complete o questionário para calcular sua pegada de carbono e descobrir seu impacto no planeta",
                                        buttonTitle: "Calcular pegada de carbono",
                                        buttonAction: {
                                            router.path.append(Route.footprint)
                                        }
                                    )
                                } else {
                                    NeutralizedCarbonComponent(
                                        neutralizedPercentage: viewModel.percentageCO2User(),
                                        month: viewModel.month,
                                        monthlyObjective: Double(viewModel.monthlyObjective),
                                        neutralizedAmount: viewModel.neutralizedAmountThisMonth(),
                                        editAction: {
                                            router.path.append(Route.footprint)
                                        }
                                    )
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Minhas contribuições")
                                    .font(.system(.title3, weight: .semibold))
                                
                                if viewModel.userPins.count == 0 {
                                    EmptyComponent(
                                        bgColor: .backgroundPrimary,
                                        cornerColor: .primitivePrimary,
                                        subtitle: "Nenhuma árvore registrada",
                                        description: "Comece a mapear árvores para acompanhar o CO₂ já capturado pelas suas contribuições.",
                                        buttonTitle: "Registrar primeira árvore",
                                        buttonAction: {
                                            router.path.append(Route.registerTree)
                                        }
                                    )
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(Array(viewModel.userPins.reversed()), id: \.id) { pin in
                                                if let tree = viewModel.getTree(for: pin) {
                                                    ContribuitionTreeComponent(
                                                        treeName: tree.species,
                                                        treeCO2: tree.totalCO2,
                                                        treeImage: pin.image ?? UIImage()
                                                    )
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                    }
                                    .padding(.horizontal, -16)
                                }
                            }
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Força da comunidade")
                                    .font(.system(.title3, weight: .semibold))
                                
                                if viewModel.totalTrees == 0 {
                                    EmptyComponent(
                                        bgColor: .backgroundPrimary,
                                        cornerColor: .primitivePrimary,
                                        icon: "person.3",
                                        title: "Juntos ampliamos o impacto positivo",
                                        subtitle: "Somando esforços pelo futuro",
                                        description: "Aqui apareceram os dados mapeados de toda a comunidade, unidos para futuro mais sustentável para todos"
                                    )
                                }
                                else {
                                    VStack(alignment: .leading, spacing: 16) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "person.3")
                                            Text("Juntos ampliamos o impacto positivo")
                                        }
                                        .font(.caption2)
                                        
                                        CommunityDataComponent(
                                            icon: .treeIcon,
                                            title: "\(viewModel.totalTrees) árvores",
                                            infoType: .trees
                                        )
                                        CommunityDataComponent(
                                            icon: .honeycomb,
                                            title: "\(viewModel.totalSpecies) espécies diferentes",
                                            infoType: .species
                                        )
                                        CommunityDataComponent(
                                            icon: .co2Cloud,
                                            title: String(format: "%.1f t de CO² sequestrados", viewModel.totalCO2Sequestration()),
                                            infoType: .co2,
                                            co2Number: viewModel.lapsEarth(totalCO2: viewModel.totalCO2Sequestration())
                                        )
                                        CommunityDataComponent(
                                            icon: .smallPlant,
                                            title: String(format: "%.1f t de O² para o planeta", viewModel.totalO2()),
                                            infoType: .oxygen,
                                            oxygenNumber: viewModel.oxygenPerPerson(totalOxygen: viewModel.totalO2())
                                        )
                                        
                                    }
                                    .padding(20)
                                    .background(.backgroundSecondary)
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                }
                                
                            }
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Juntos pela causa")
                                    .font(.system(.title3, weight: .semibold))
                                InviteFriendsComponent(shareAction: {
                                    viewModel.isShowingShareSheet = true
                                })
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .refreshable {
                        await viewModel.fetchData()
                    }
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .footprint:
                            FootprintView(
                                viewModel: FootprintViewModel(
                                    repository: FootprintRepository(userService: UserService(), footprintService: FootprintService())
                                )
                            )
                            .toolbar(.hidden, for: .tabBar)
                            .navigationBarBackButtonHidden(true)
                            
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
                            OnboardingView(viewModel: OnboardingViewModel(userDefaultService: UserDefaultService(), userService: UserService()))
                        }
                    }
                    .toolbar(content: {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                ProfileView(viewModel: ProfileViewModel(repository: ProfileRepository(pinService: PinService(), userService: UserService(), treeService: ScannedTreeService(), footprintService: FootprintService(), userDefaultService: UserDefaultService())))
                            } label: {
                                Image(systemName: "person")
                            }
                        }
                    })
                    .background(.backgroundPrimary)
                    .foregroundStyle(.primitivePrimary)
                    .sheet(isPresented: $viewModel.isShowingShareSheet) {
                        ShareSheet(items: ["Olha que legal o App Cerne: ele calcula quanto de carbono as árvores da sua cidade conseguem reter para ajudar a limpar o ar. Achei que você ia gostar. https://apps.apple.com/br/app/cerne-captura-de-co/id6751984534"])
                    }
                    .navigationTitle("Olá, \(viewModel.userName)!")
                }
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}
