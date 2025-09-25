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
    @Binding var selection: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center,spacing: 10) {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 36, height: 26)
                
                Text(title)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
            }
            
            HStack (alignment: .center, spacing: 8) {
                Text(description)
                    .font(.callout)
                    .foregroundStyle(.labelSecondary)
                
                Spacer()
                
                PickerComponent(title: "Selecionar", options: options, isEnabled: true, selection: $selection)
            }
        }
    }
}


#Preview {
    CarbonEmmiters(iconName: "car", title: "1dsahjdgdsahjdjsadsajh23", description: "12dhsaj dghjsadsa djsadjas dhsadhds hagdasdyg dgsajgd jas jadjas gda3", options: ["123"], selection: .constant(""))
}
