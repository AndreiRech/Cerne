//
//  ProfileView.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 25/09/25.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel: ProfileViewModelProtocol
    @State private var isShowingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Sua trajetória nos inspira!")
                            .foregroundStyle(.primitive1)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        if viewModel.userPins.isEmpty {
                            EmptyComponent(bgColor: .CTA, cornerColor: .primitive1, subtitle: "Nenhuma árvore registrada", description: "Comece a mapear árvores para acompanhar o CO₂ já capturado pelas suas contribuições", buttonTitle: "Registrar primeira árvore")
                        } else {
                            HStack(alignment: .center, spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(String(viewModel.userPins.count))
                                        .foregroundStyle(.labelPrimary)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    
                                    Text("árvores\nregistradas")
                                        .foregroundStyle(.labelPrimary)
                                        .font(.body)
                                        .fontWeight(.regular)
                                        
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 26)
                                        .foregroundStyle(.CTA)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 26)
                                                .stroke(.primitive1, lineWidth: 1)
                                        )
                                )
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(viewModel.totalCO2User())
                                        .foregroundStyle(.labelPrimary)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    
                                    Text("quilos de CO²\nsequestrados ")
                                        .foregroundStyle(.labelPrimary)
                                        .font(.body)
                                        .fontWeight(.regular)
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 26)
                                        .foregroundStyle(.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 26)
                                                .stroke(.primitive1, lineWidth: 1)
                                        )
                                )
                            }
                            
                            Text("Reunimos aqui várias informações sobre sua trajetória dentro do Cerne. Fique a vontade para explorar")
                                .foregroundStyle(.primitive1)
                                .font(.footnote)
                                .fontWeight(.regular)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .center, spacing: 0) {
                            Text("Minha pegada de carbono")
                                .foregroundStyle(.primitive1)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            if /*!vm.getFootprint().isEmpty*/ false {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .foregroundStyle(.primitive1)
                                        .font(.body)
                                        .fontWeight(.regular)
                                }
                            }
                        }
                        
                        if /*vm.getFootprint().isEmpty*/ true {
                            EmptyComponent(bgColor: .white, cornerColor: .primitive1, subtitle: "Cálculo ainda não realizado", description: "Complete o questionário para calcular sua pegada de carbono e descobrir seu impacto no planeta", buttonTitle: "Calcular pegada de carbono")
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                                        .foregroundStyle(.labelPrimary)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                    
                                    HStack(alignment: .bottom, spacing: 8) {
                                        Text(/*vm.getFootprint()*/ "2.496 Kg")
                                            .foregroundStyle(.labelPrimary)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            
                                        Text("de CO² por ano")
                                            .foregroundStyle(.labelPrimary)
                                            .font(.title3)
                                            .fontWeight(.regular)
                                    }
                                }
                                
                                Text("As decisões e hábitos do seu cotidiano estão diretamente associados ao seu impacto no planeta")
                                    .foregroundStyle(.labelPrimary)
                                    .font(.footnote)
                                    .fontWeight(.regular)
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 26)
                                    .foregroundStyle(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 26)
                                            .stroke(.primitive1, lineWidth: 1)
                                    )
                            )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Meu progresso anual")
                            .foregroundStyle(.primitive1)
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
                        .foregroundStyle(.primitive1)
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
        }
    }
}
