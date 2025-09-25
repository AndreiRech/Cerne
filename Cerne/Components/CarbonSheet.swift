//
//  CarbonSheet.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

import SwiftUI

struct CarbonSheet: View {
    let page: Int
    @State private var selections: [CarbonEmittersEnum: String] = [:]

    private var emittersForCurrentPage: [CarbonEmittersEnum] {
        let allEmitters = CarbonEmittersEnum.allCases
        let itemsPerPage = 5
        
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, allEmitters.count)
        
        if startIndex >= allEmitters.count {
            return []
        }
        
        return Array(allEmitters[startIndex..<endIndex])
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Pegada de Carbono")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.labelPrimary)
            
            Text("Para **calcular sua pegada de carbono**, precisamos entender alguns **hábitos do seu cotidiano.**")
                .padding(.bottom)
                .font(.footnote)
                .foregroundStyle(.labelPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            ForEach(emittersForCurrentPage, id: \.self) { emitter in
                CarbonEmmiters(
                    iconName: emitter.iconName,
                    title: emitter.title,
                    description: emitter.description,
                    options: emitter.getPickerOptions(),
                    selection: Binding(
                        get: { selections[emitter] ?? emitter.getPickerOptions().first! },
                        set: { selections[emitter] = $0 }
                    )
                )
            }
        }
        .padding()
        .glassEffect()
        .onAppear {
            for emitter in emittersForCurrentPage {
                if selections[emitter] == nil {
                    selections[emitter] = emitter.getPickerOptions().first!
                }
            }
        }
    }
}

struct CarbonSheet_Previews: PreviewProvider {
    static var previews: some View {
        CarbonSheet(page: 1)
    }
}

