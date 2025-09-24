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
                    NeutralizedCarbonComponent()
                    
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Minhas contribuições")
                        .font(.system(.title3, weight: .semibold))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ContribuitionTreeComponent(treeName: "Ipe-Amarelo", treeCO2: 1002, treeImage: .treeTest)
                            //TO DO: Tirar essa linha de cima
                            ForEach(viewModel.userPins) { pin in
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
                        
                        //TO DO: Arrumar isso aq pra nao ficar mockado
                        CommunityDataComponent(icon: .treeIcon, title: "12.500 árvores", infoType: .trees)
                        CommunityDataComponent(icon: .treeIcon, title: "180 espécies diferentes", infoType: .species)
                        CommunityDataComponent(icon: .treeIcon, title: "25 t de CO² sequestrados", infoType: .co2, co2Number: 2.7)
                        CommunityDataComponent(icon: .treeIcon, title: "18 t de O² para o planeta", infoType: .oxygen, oxygenNumber: 63)
                        
                    }
                    .padding(20)
                    .background(.black.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Juntos pela causa")
                        .font(.system(.title3, weight: .semibold))
                    InviteFriendsComponent(shareAction: {
                        print("Botão no componente foi tocado. Mudando o estado na View principal.")
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
            }
        }
        .foregroundStyle(.primitive1)
        .sheet(isPresented: $isShowingShareSheet) {
            ShareSheet(items: ["Vem mapear árvores!"])
        }
        
    }
}


#Preview {
    TodayView(viewModel: TodayViewModel(pinService: PinService(), userService: UserService()))
    
}
