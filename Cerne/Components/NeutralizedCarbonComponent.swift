//
//  NeutralizedCarbonComponent.swift
//  Cerne
//
//  Created by Maria Santellano on 24/09/25.
//

import SwiftUI

struct NeutralizedCarbonComponent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "leaf.arrow.trianglehead.clockwise")
                Text("Mantenha o ritmo para atingir a meta anual")
            }
            .font(.caption2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("32% de CO² neutralizado") //TO DO: Arruma esse text
                    .font(.system(.title3, weight: .semibold))
                Text("Objetivo de Outubro: 208 kg de CO²")
                    .font(.footnote)
                    .foregroundStyle(.labelSecondary)

            }

            
        }
        //TO DO: Ver a largura do coisa que ta errado
        .padding(20)
        .background(.CTA)
        .clipShape(RoundedRectangle(cornerRadius: 26))
    }
}
