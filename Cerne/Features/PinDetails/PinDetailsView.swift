//
//  PinDetailsView.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 10/09/25.
//

import SwiftUI

struct PinDetailsView: View {
    let pin: Pin
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                HStack() {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.gray)
                            .font(.system(size: 17, weight: .medium, design: .default))
                            .frame(width: 44, height: 44, alignment: .center)
                            .background(.thickMaterial, in: Circle())
                    }
                    
                    Spacer()
                    
                    Text(pin.tree.species)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.gray)
                            .font(.system(size: 17, weight: .medium, design: .default))
                            .frame(width: 44, height: 44, alignment: .center)
                            .padding(.vertical, 4)
                            .background(.thickMaterial, in: Circle())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
                
                HStack(alignment: .top, spacing: 10) {
                    Image(.treeDefault)
                        .resizable()
                        .frame(width: 102, height: 137, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sobre a árvore")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        Text("Handroanthus albus(nome científico) é nativo do Brasil, presente na Mata Atlântica e no Cerrado. Alcança até 30 metros e floresce no fim do inverno, sendo símbolo nacional.")
                            .font(.footnote)
                            .fontWeight(.regular)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 10){
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                        .foregroundStyle(.primary)
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .frame(width: 26, height: 26, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("668 kg de CO² capturado")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        Text("A captura dessa árvore equivale a emissão de um carro, movido a gasolina, rodando 2.890 km")
                            .font(.footnote)
                            .fontWeight(.regular)
                    }
                }
                
                HStack(alignment: .top, spacing: 10){
                    Image(systemName: "hourglass")
                        .foregroundStyle(.primary)
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .frame(width: 26, height: 26, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("10 anos")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        Text("Aproximadamente")
                            .font(.footnote)
                            .fontWeight(.regular)
                    }
                }
                
                HStack(alignment: .top, spacing: 10){
                    Image(systemName: "calendar.badge.checkmark")
                        .foregroundStyle(.primary)
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .frame(width: 26, height: 26, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("02/10/2025")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        Text("Data de registro no Cerne")
                            .font(.footnote)
                            .fontWeight(.regular)
                    }
                }
                
                HStack(alignment: .top, spacing: 10){
                    Image(systemName: "person.icloud.fill")
                        .foregroundStyle(.primary)
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .frame(width: 26, height: 26, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Marina Carvalho")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        Text("Usuário responsável pelo mapeamento")
                            .font(.footnote)
                            .fontWeight(.regular)
                    }
                }
            }
            
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "exclamationmark.bubble")
                        .foregroundStyle(.primary)
                    Text("Relatar um Problema")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(.yellow)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.tertiary)
                )
            }
        }
        .padding(.horizontal, 23)
    }
}
