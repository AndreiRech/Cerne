//
//  CarbonSheet.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

import SwiftUI

struct CarbonSheet: View {
    let page: Int
    let isEnabled: Bool
    let selections: [CarbonEmittersEnum: String]
    let emitters: [CarbonEmittersEnum]
    let onUpdate: (CarbonEmittersEnum, String) -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Pegada de Carbono")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.labelPrimary)
            
            Text(isEnabled ? "Para **calcular sua pegada de carbono**, precisamos entender alguns **hábitos do seu cotidiano**" : "Verifique suas informações antes de concluir o cálculo da sua pegada de carbono")
                .padding(.bottom)
                .font(.footnote)
                .foregroundStyle(.labelPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            ForEach(emitters, id: \.self) { emitter in
                CarbonEmmiters(
                    iconName: emitter.iconName,
                    title: emitter.title,
                    description: emitter.description,
                    options: emitter.getPickerOptions(),
                    isEnabled: isEnabled,
                    selection: Binding(
                        get: { selections[emitter] ?? "Selecionar" },
                        set: { newValue in onUpdate(emitter, newValue) }
                    )
                )
                .lineLimit(page < 3 ? 3 : 1)    
            }
        }
        .padding()
    }
}

#Preview {
    // State é necessário para que as seleções no preview sejam interativas
    @Previewable @State var selections: [CarbonEmittersEnum: String] = [
        .car: "Gasolina / Álcool",
        .km: "Selecionar"
    ]
    
    // Define quais perguntas (emissores) aparecerão nesta visualização
    let emittersForPreview: [CarbonEmittersEnum] = [
        .car,
        .km,
        .bus
    ]
    
    // Retorna a view com dados mocados
    return CarbonSheet(
        page: 1,
        isEnabled: true,
        selections: selections,
        emitters: emittersForPreview,
        onUpdate: { emitter, newValue in
            selections[emitter] = newValue
        }
    )
    .padding()
//    .background(.gray.opacity(0.1))
}
