//
//  TodayView.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import SwiftUI

struct TodayView: View {
    @State var viewModel: TodayViewModelProtocol
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Meu impacto no planeta")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primitive1)
                    
                    Text("Aquele coisa que tem a barra")
                    
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Minhas contribuições")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primitive1)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
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
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primitive1)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.3")
                            Text("Juntos ampliamos o impacto positivo")
                        }
                        .font(.caption2)
                        .foregroundStyle(.primitive1)
                        
                        //TO DO: Arrumar isso aq pra nao ficar mockado
                        CommunityDataComponent(icon: .treeIcon, title: "12.500 árvores", infoType: .trees)
                        CommunityDataComponent(icon: .treeIcon, title: "180 espécies diferentes", infoType: .species)
                        CommunityDataComponent(icon: .treeIcon, title: "25 t de CO² sequestrados", infoType: .co2, co2Number: 2.7)
                        CommunityDataComponent(icon: .treeIcon, title: "18 t de O² para o planeta", infoType: .oxygen, oxygenNumber: 63)
                        
                    }
                    .padding(.horizontal, 20) 
                    .padding(.top, 20)
                    .background(.blue)
                    //TO DO: Arrumar o background e dar a borda
                    
                }
                
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Juntos pela causa")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primitive1)
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .onAppear {
            Task {
                await viewModel.fetchUserPins()
            }
        }
    }
}
