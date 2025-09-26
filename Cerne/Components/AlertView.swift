//
//  AlertView.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 26/09/25.
//

import SwiftUI

struct AlertView: View {
    let title: String
    let message: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 10){
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 22)
                    .padding(.top, 22)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 22)
            }
            
            HStack(spacing: 16) {
                Button("Cancelar") {
                    onCancel()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(.thinMaterial)
                .foregroundStyle(.primitive2)
                .font(.callout)
                .clipShape(RoundedRectangle(cornerRadius: 100))

                Button("Continuar") {
                    onConfirm()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(.primitive2)
                .foregroundStyle(.white)
                .fontWeight(.medium)
                .font(.body)
                .clipShape(RoundedRectangle(cornerRadius: 100))
                
            }
            .padding(14)
        }
        .glassEffect(in: .rect(cornerRadius: 26))
    }
}
