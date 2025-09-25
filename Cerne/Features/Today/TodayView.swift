//
//  TodayView.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import SwiftUI

struct TodayView: View {
    @State var viewModel: TodayViewModelProtocol
    @State private var isShowingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Meu impacto no planeta")
                        .font(.system(.title3, weight: .semibold))
                    // TO DO: Arrumar a meta e o nome do mes
                    NeutralizedCarbonComponent(neutralizedPercentage: 45, month: viewModel.month, monthlyObjective: Double(viewModel.monthlyObjective))
                    
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Minhas contribuições")
                        .font(.system(.title3, weight: .semibold))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ContribuitionTreeComponent(treeName: "Ipe-Amarelo", treeCO2: 1002, treeImage: .treeTest)
                            //TO DO: Tirar essa linha de cima
                            ForEach(viewModel.userPins.reversed()) { pin in
                                ContribuitionTreeComponent(
                                    treeName: pin.tree?.species ?? "", //TO DO: Pegar o common name
                                    treeCO2: pin.tree?.totalCO2 ?? 0,
                                    treeImage: UIImage(data: pin.image ?? Data()) ?? UIImage(named: "TreeTest")!
                                )
                            }
                        }
                    }
                    
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Força da comunidade")
                        .font(.system(.title3, weight: .semibold))
                    
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
                            icon: .treeIcon,
                            title: "\(viewModel.totalSpecies) espécies diferentes",
                            infoType: .species
                        )
                        CommunityDataComponent(
                            icon: .treeIcon,
                            title: String(format: "%.1f t de CO² sequestrados", viewModel.totalCO2Sequestration()),
                            infoType: .co2,
                            co2Number: viewModel.lapsEarth(totalCO2: viewModel.totalCO2Sequestration())
                        )
                        CommunityDataComponent(
                            icon: .treeIcon,
                            title: String(format: "%.1f t de O² para o planeta", viewModel.totalO2()),
                            infoType: .oxygen,
                            oxygenNumber: viewModel.oxygenPerPerson(totalOxygen: viewModel.totalO2())
                        )
                        
                    }
                    .padding(20)
                    .background(.black.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Juntos pela causa")
                        .font(.system(.title3, weight: .semibold))
                    InviteFriendsComponent(shareAction: {
                        self.isShowingShareSheet = true
                    })
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .background(
            LinearGradient(
                stops: [
                    .init(color: .white, location: 0.0),
                    .init(color: .blueBackground, location: 0.4)
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
        .onAppear {
            Task {
                await viewModel.fetchUserPins()
                await viewModel.fetchAllPins()

            }
        }
        .foregroundStyle(.primitive1)
        .sheet(isPresented: $isShowingShareSheet) {
            ShareSheet(items: ["Olha que legal o App Cerne: ele calcula quanto de carbono as árvores da sua cidade conseguem reter para ajudar a limpar o ar. Achei que você ia gostar. LINK"])
        }
        
    }
}


#Preview {
    TodayView(viewModel: TodayViewModel(pinService: PinService(), userService: UserService()))
    
}
