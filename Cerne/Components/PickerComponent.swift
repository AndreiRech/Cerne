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
    
    var body: some View {
        Picker(title, selection: $selection) {
            Text("Selecionar").tag("Selecionar")
            ForEach(options, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.menu)
        .tint(isEnabled ? .green : .gray)
    }
}
