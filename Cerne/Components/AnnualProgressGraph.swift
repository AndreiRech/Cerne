//
//  AnnualProgressGraph.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 30/09/25.
//

import SwiftUI

struct AnnualProgressGraph: View {
    let data: [MonthlyData]
    let CO2AnualPercent: Int
    let monthlyObjective: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "leaf.arrow.trianglehead.clockwise")
                        .foregroundStyle(.primitivePrimary)
                        .font(.body)
                        .fontWeight(.regular)
                    
                    HStack(alignment: .bottom, spacing: 8) {
                        Text("\(CO2AnualPercent)%")
                            .foregroundStyle(.primitivePrimary)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("de CO² neutralizado")
                            .foregroundStyle(.primitivePrimary)
                            .font(.title3)
                            .fontWeight(.regular)
                    }
                }

                Text("Cada novo registro conta para um futuro mais sustentável para todos")
                    .foregroundStyle(.primitivePrimary)
                    .font(.footnote)
                    .fontWeight(.regular)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 16) {
                    ForEach(data) { monthData in
                        VStack(spacing: 6) {
                            GeometryReader { geo in
                                ZStack(alignment: .bottom) {
                                    Capsule()
                                        .fill(.CTA)
                                        .frame(height: geo.size.height * monthData.normalizedHeight)
                                        .animation(.spring(), value: monthData.normalizedHeight)
                                    
                                    Capsule()
                                        .fill(.backgroundPrimary.opacity(0.0))
                                        .overlay(
                                            Capsule().stroke(Color.primitivePrimary, lineWidth: 1)
                                        )
                                }
                            }
                            .frame(width: 13, height:  50)

                            Text(monthData.month)
                                .foregroundStyle(.primitivePrimary)
                                .font(.footnote)
                                .fontWeight(.regular)
                        }
                    }
                }

                Text("Objetivo mensal: \(monthlyObjective) kg de CO²")
                    .font(.footnote)
                    .fontWeight(.regular)
                    .foregroundStyle(.primitiveSecondary)
            }

        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .foregroundStyle(.backgroundPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(.primitivePrimary, lineWidth: 1)
                )
        )
    }
}
