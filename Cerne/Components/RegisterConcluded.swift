//
//  RegisterConcluded.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 26/09/25.
//

import SwiftUI

struct RegisterConcluded: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.bottom, 24)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .glassEffect(in: .rect(cornerRadius: 26))
    }
}

#Preview {
    RegisterConcluded(title: "Registro", message: "Pegada de carbono")
}
