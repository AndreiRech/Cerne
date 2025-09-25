//
//  FootprintViewModel.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

import SwiftUI
import Combine

@Observable
class FootprintViewModel: FootprintViewModelProtocol {
    private let footprintService: FootprintServiceProtocol
    var currentPage: Int = 1
    var selections: [CarbonEmittersEnum: String] = [:]
    
    var totalQuestionPages: Int {
        let totalItems = CarbonEmittersEnum.allCases.count
        let itemsPerPage = 5
        return (totalItems + itemsPerPage - 1) / itemsPerPage
    }
    
    var totalPages: Int {
        return totalQuestionPages + 1
    }
    
    var isAbleToSave: Bool {
        let allQuestionsAnswered = selections.count == CarbonEmittersEnum.allCases.count
        let noPlaceholderAnswers = !selections.values.contains("Selecionar")
        
        return allQuestionsAnswered && noPlaceholderAnswers
    }
    
    init(footprintService: FootprintServiceProtocol) {
        self.footprintService = footprintService
        
        for emitter in CarbonEmittersEnum.allCases {
            selections[emitter] = "Selecionar"
        }
    }
    
    func emittersForPage(_ page: Int) -> [CarbonEmittersEnum] {
        let allEmitters = CarbonEmittersEnum.allCases
        let itemsPerPage = 5
        
        let startIndex = (page - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, allEmitters.count)
        
        if startIndex >= allEmitters.count {
            return []
        }
        
        return Array(allEmitters[startIndex..<endIndex])
    }
    
    func updateSelection(for emitter: CarbonEmittersEnum, to newValue: String) {
        selections[emitter] = newValue
    }
    
    func saveFootprint() {
        if isAbleToSave {
            print("Salvando dados...")
            print(selections)
        } else {
            print("Não é possível salvar. Faltam respostas.")
        }
    }
}
