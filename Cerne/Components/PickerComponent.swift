//
//  PickerComponent.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

import SwiftUI

struct PickerComponent: View {
    let title: String
    let options: [String]
    let isEnabled: Bool
    @Binding var selection: String
    
    private var displayText: String {
        let maxLength = 10
        if selection.count > maxLength {
            return selection.prefix(maxLength) + "..."
        }
        return selection
    }
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selection = option
                }
            }
        } label: {
            HStack(spacing: 3) {
                Text(displayText)
                
                Image(systemName: "chevron.up.chevron.down")
            }
            .fontWeight(.semibold)
            .foregroundStyle(isEnabled ? .green : .gray)
        }
        .disabled(!isEnabled)
    }
}
