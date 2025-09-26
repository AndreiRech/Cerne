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
    var neutralizedAmount: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "leaf.arrow.trianglehead.clockwise")
                Text("Mantenha o ritmo para atingir a meta anual")
            }
            .font(.caption2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(neutralizedPercentage)% de CO² neutralizado")
                    .font(.system(.title3, weight: .semibold))
                Text("Objetivo de \(month): \(Int(monthlyObjective)) kg de CO²")
                    .font(.footnote)
                    .foregroundStyle(.labelSecondary)
                
                ProgressView(value: min(neutralizedAmount, monthlyObjective), total: monthlyObjective)
                    .progressViewStyle(CustomProgressViewStyle())
            }
        }
        .padding(20)
        .background(.CTA)
        .clipShape(RoundedRectangle(cornerRadius: 26))
    }
}
