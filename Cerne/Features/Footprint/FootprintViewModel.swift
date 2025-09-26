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
    private let userService: UserServiceProtocol
    var currentPage: Int = 1
    var selections: [CarbonEmittersEnum: String] = [:]
    var showDiscardAlert: Bool = false
    var showConludedAlert: Bool = false
    
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
    
    init(footprintService: FootprintServiceProtocol, userService: UserServiceProtocol) {
        self.footprintService = footprintService
        self.userService = userService
        
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
    
    func resetSelections() {
        for emitter in CarbonEmittersEnum.allCases {
            selections[emitter] = "Selecionar"
        }
        currentPage = 1
    }
    
    func saveFootprint() async {
        if isAbleToSave {
            let (_, userResponses) = calculateCarbonEmissions()
            
            do {
                let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
                try footprintService.createOrUpdateFootprint(for: currentUser, with: userResponses)

                showConludedAlert = true
                
            } catch {
                print("Erro ao salvar a pegada de carbono: \(error.localizedDescription)")
            }
            
        } else {
            print("Não é possível salvar. Faltam respostas.")
        }
    }
    
    func calculateCarbonEmissions() -> (total: Double, responses: [Response]) {
        
        var totalEmittedCarbon: Double = 0.0
        var userResponses: [Response] = []

        do {
            let questions = try footprintService.getQuestions(fileName: "Questions")

            for (emitter, selectedOptionText) in selections {
                if let question = questions.first(where: { $0.text == emitter.description }) {
                    if let option = question.options.first(where: { $0.text == selectedOptionText }) {
                        totalEmittedCarbon += option.value
                        
                        let newResponse = Response(questionId: question.id, optionId: option.id, value: option.value)
                        userResponses.append(newResponse)
                    }
                }
            }
        } catch {
            print("Erro ao calcular as emissões: \(error)")
        }
        
        return (totalEmittedCarbon, userResponses)
    }
}
