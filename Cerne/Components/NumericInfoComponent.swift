//
//  NumericInfoComponent.swift
//  Cerne
//
//  Created by Maria Santellano on 16/09/25.
//

import SwiftUI

struct NumericInfoComponent: View {
    let title: String
    let subtitle: String
    let isHeight: Bool
    
    @Binding var value: Double
    @Binding var isEditing: Bool
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 7) {
            if isHeight {
                Image(systemName: "base.unit")
                    .font(.title3)
                    .foregroundStyle(.CTA)
                    .rotationEffect(.degrees(90))
            } else {
                Image(systemName: "base.unit")
                    .font(.title3)
                    .foregroundStyle(.CTA)
            }
            
            if isEditing {
                VStack(alignment: .leading, spacing: 0) {
                    TextField("", value: $value, formatter: numberFormatter)
                        .keyboardType(.decimalPad)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primitivePrimary)
                    
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.primitivePrimary)
                }
                Spacer()
                
                if value != 0  {
                    Button(action: { value = 0.0 }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.CTA)
                    }
                }
                
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primitivePrimary)
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.primitivePrimary)
                }
            }
            
            Spacer()
        }
    }
}
