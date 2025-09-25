//
//  NeutralizedCarbonComponent.swift
//  Cerne
//
//  Created by Maria Santellano on 24/09/25.
//

import SwiftUI

struct NeutralizedCarbonComponent: View {
    var neutralizedPercentage: Int
    var month: String
    var monthlyObjective: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "leaf.arrow.trianglehead.clockwise")
                Text("Mantenha o ritmo para atingir a meta anual")
            }
            .font(.caption2)
            
            // TO DO: A meta mensal é a pegada dividida por 12, ai a barra vai crescendo conforme a pessoa vai coletando arvores, ent o value é o quanto ela coletou e o total é o objective
            VStack(alignment: .leading, spacing: 4) {
                Text("\(neutralizedPercentage)% de CO² neutralizado")
                    .font(.system(.title3, weight: .semibold))
                Text("Objetivo de \(month): \(Int(monthlyObjective)) kg de CO²")
                    .font(.footnote)
                    .foregroundStyle(.labelSecondary)
                
                ProgressView(value: 100, total: monthlyObjective)
                    .overlay(
                        Capsule()
                            .stroke(.primitive1, lineWidth: 0.5)
                    )
                // TO DO: Arrumar esse problema q é essa linha de baixo q faz com que ele fique dessa forma
                    .scaleEffect(x: 1.0, y: 3.0, anchor: .center)
                    .tint(.primitive1)
                

            }
            
            
        }
        .padding(20)
        .background(.CTA)
        .clipShape(RoundedRectangle(cornerRadius: 26))
    }
}

#Preview{
    NeutralizedCarbonComponent(neutralizedPercentage: 34, month: "Outubro", monthlyObjective: 208)
}
