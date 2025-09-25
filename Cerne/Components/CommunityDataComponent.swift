//
//  CommunityDataComponent.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import SwiftUI

enum CommunityInfoType {
    case trees, species, co2, oxygen
}

struct CommunityDataComponent: View {
    var icon: UIImage
    var title: String
    let infoType: CommunityInfoType
    var co2Number: Double?
    var oxygenNumber: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(uiImage: icon)
                    .font(.title3)
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primitive1)
            }
            switch infoType {
            case .trees:
                Text("Cada novo registro conta para um \(Text("futuro mais sustentável").fontWeight(.semibold)) para todos")
                    .font(.subheadline)
                    .foregroundStyle(.labelSecondary)
                
            case .species:
                Text("A biodiversidade é imensa e cada registro ajuda a \(Text("revelar toda essa riqueza").fontWeight(.semibold))")
                    .font(.subheadline)
                    .foregroundStyle(.labelSecondary)

            case .co2:
                Text("Correspondem a cerca de \(Text(String(format: "%.1f voltas ao redor da Terra", co2Number ?? 0)).fontWeight(.semibold)) de carro, movido a gasolina")
                    .font(.subheadline)
                    .foregroundStyle(.labelSecondary)
    
            case .oxygen:
                Text("Oxigênio capaz de suprir o consumo anual de cerca de \(Text(String(format: "%d pessoas", oxygenNumber ?? 0)).fontWeight(.semibold))")
                    .font(.subheadline)
                    .foregroundStyle(.labelSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}
