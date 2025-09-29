//
//  CarbonEmmiters.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

import SwiftUI
import UIKit

struct CarbonEmmiters: View {
    let iconName: String
    let title: String
    let description: String
    let options: [String]
    let isEnabled: Bool
    @Binding var selection: String
    
    var body: some View {
        if isEnabled {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center,spacing: 10) {
                    Image(systemName: iconName)
                        .frame(width: 36, height: 26)
                        .foregroundStyle(.primitivePrimary)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(title)
                        .foregroundStyle(.primitivePrimary)
                        .font(.body)
                        .fontWeight(.semibold)
                }
                
                HStack (alignment: .center, spacing: 8) {
                    Text(description)
                        .foregroundStyle(.primitiveSecondary)
                        .font(.body)
                        .fontWeight(.regular)
                    
                    Spacer()
                    
                    PickerComponent(title: "Selecionar", options: options, isEnabled: isEnabled, selection: $selection)
                }
            }
        } else {
            HStack(alignment: .center,spacing: 10) {
                Image(systemName: iconName)
                    .frame(width: 36, height: 26)
                    .foregroundStyle(.primitivePrimary)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(title)
                    .foregroundStyle(.primitivePrimary)
                    .font(.body)
                    .fontWeight(.semibold)
                
                Spacer()
                
                PickerComponent(title: "Selecionar", options: options, isEnabled: isEnabled, selection: $selection)
            }
        }
    }
}

#Preview {
    @Previewable @State var selection: String = "Selecionar"
    CarbonEmmiters(iconName: "car.fill", title: "Carro", description: "qual tipo?", options: CarbonEmittersEnum.car.getPickerOptions(), isEnabled: true, selection: $selection)
}
