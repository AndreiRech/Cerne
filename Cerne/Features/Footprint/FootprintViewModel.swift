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
    private var user: User?
    private var footprint: Footprint?
    
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
            let (_, userResponses) = await calculateCarbonEmissions()
            
            do {
                self.user = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
                guard let user = self.user else { return }
                
                self.footprint = try await footprintService.createOrUpdateFootprint(for: user, with: userResponses)

                showConludedAlert = true
                
            } catch {
                print("Erro ao salvar a pegada de carbono: \(error.localizedDescription)")
            }
            
        } else {
            print("Não é possível salvar. Faltam respostas.")
        }
    }
    
    func calculateCarbonEmissions() async -> (total: Double, responses: [ResponseData]) {
        
        var totalEmittedCarbon: Double = 0.0
        var userResponses: [ResponseData] = []

        do {
            let questions = try footprintService.getQuestions(fileName: "Questions")
            
            for (emitter, selectedOptionText) in selections {
                if let question = questions.first(where: { $0.text == emitter.description }) {
                    if let option = question.options.first(where: { $0.text == selectedOptionText }) {
                        totalEmittedCarbon += option.value
                        
                        let newResponse = ResponseData(questionId: question.id, optionId: option.id, value: option.value)
                        userResponses.append(newResponse)
                    }
                }
            }
        } catch {
            print("Erro ao calcular as emissões: \(error)")
        }
        
        return (totalEmittedCarbon, userResponses)
    }
    
    func loadUserSelections() async {
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            if let userFootprint = try footprintService.fetchFootprint(for: currentUser),
               let responses = userFootprint.responses {
                let questions = try footprintService.getQuestions(fileName: "Questions")
                for response in responses {
                    if let question = questions.first(where: { $0.id == response.questionId }),
                       let option = question.options.first(where: { $0.id == response.optionId }),
                       let emitter = CarbonEmittersEnum.allCases.first(where: { $0.description == question.text }) {
                        selections[emitter] = option.text
                    }
                }
            }
        } catch {
            print("Erro ao carregar seleções do usuário: \(error.localizedDescription)")
        }
    }
}
