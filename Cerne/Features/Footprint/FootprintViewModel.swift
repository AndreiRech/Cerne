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
    private let repository: FootprintRepositoryProtocol
    
    private var user: User?
    private var footprint: Footprint?
    private var responses: [Response] = []
    private var questions: [Question] = []
    
    var currentPage: Int = 1
    var selections: [CarbonEmittersEnum: String] = [:]
    var showDiscardAlert: Bool = false
    var showConludedAlert: Bool = false
    var isLoading: Bool = false
    
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
    
    var isOverlayVisible: Bool {
        showDiscardAlert || showConludedAlert
    }
    
    init(repository: FootprintRepositoryProtocol) {
        self.repository = repository
        
        for emitter in CarbonEmittersEnum.allCases {
            selections[emitter] = "Selecionar"
        }
    }
    
    func fetchData() async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            let data = try await repository.fetchFootprintData()
            
            self.user = data.currentUser
            self.footprint = data.userFootprint
            self.responses = data.responses
            
            self.questions = try repository.getQuestions()
            
            loadUserSelections()
        } catch {
            print("Erro ao buscar dados do repositório: \(error.localizedDescription)")
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
            self.isLoading = true
            defer { self.isLoading = false }
            do {
                self.questions = try repository.getQuestions()
                
                let (_, userResponses) = calculateCarbonEmissions()
                
                guard let user = self.user else { return }
                
                self.footprint = try await repository.saveFootprint(for: user, with: userResponses)
                
                showConludedAlert = true
            } catch {
                print("Erro ao salvar a pegada de carbono: \(error.localizedDescription)")
            }
        } else {
            print("Não é possível salvar. Faltam respostas.")
        }
    }
    
    func calculateCarbonEmissions() -> (total: Double, responses: [ResponseData]) {
        var totalEmittedCarbon: Double = 0.0
        var userResponses: [ResponseData] = []
        
        for (emitter, selectedOptionText) in selections {
            if let question = questions.first(where: { $0.text == emitter.description }) {
                if let option = question.options.first(where: { $0.text == selectedOptionText }) {
                    totalEmittedCarbon += option.value
                    
                    let newResponse = ResponseData(questionId: question.id, optionId: option.id, value: option.value)
                    userResponses.append(newResponse)
                }
            }
        }
        
        return (totalEmittedCarbon, userResponses)
    }
    
    func loadUserSelections() {
        for response in responses {
            if let question = questions.first(where: { $0.id == response.questionId }),
               let option = question.options.first(where: { $0.id == response.optionId }),
               let emitter = CarbonEmittersEnum.allCases.first(where: { $0.description == question.text }) {
                selections[emitter] = option.text
            }
        }
    }
}
