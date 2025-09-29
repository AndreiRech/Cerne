//
//  TreeInfoComponent.swift
//  Cerne
//
//  Created by Maria Santellano on 16/09/25.
//

import SwiftUI

struct TreeInfoComponent: View {
    let title: String
    let subtitle: String
    
    @Binding var value: String
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack(spacing: 7) {
            Image(.treeIcon)
                .font(.title3)
            
            if isEditing {
                VStack(alignment: .leading, spacing: 0) {
                    TextField("", text: $value)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primitivePrimary)

                    
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.primitivePrimary)
                }
                
                Spacer()
                
                if !value.isEmpty {
                    Button(action: { value = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
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

