//
//  ValidationView.swift
//  Cerne
//
//  Created by Maria Santellano on 30/09/25.
//

import SwiftUI

struct ValidationView: View {
    var tree: ScannedTree?
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Cálculo finalizado!")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 7) {
                Text(tree?.species ?? "")
                    .lineLimit(1)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                HStack(spacing: 7) {
                    Image(.treeIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 17)
                    Text("Espécie identificada")
                        .font(.footnote)
                }
            }
            
            VStack(spacing: 7) {
                Text(String(format: "%.1f kg de CO₂", tree?.totalCO2 ?? 0))
                    .font(.title3)
                    .fontWeight(.semibold)
                
                HStack(spacing: 7) {
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 17)
                    Text("Sequestrado da atmosfera")
                        .font(.footnote)
                }
            }
            Text("Capacidade de sequestro de CO₂ verificada e árvore adicionada ao mapa.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                router.popToRoot()
                router.selectedTab = 1
            } label: {
                Text("Concluir")
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
            }
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .foregroundStyle(.CTA)
            )
        }
        .foregroundStyle(.primitivePrimary)
        .padding(.horizontal, 23)
        .padding(.vertical, 25)
        .glassEffect(in: .rect(cornerRadius: 26))
    }
}
