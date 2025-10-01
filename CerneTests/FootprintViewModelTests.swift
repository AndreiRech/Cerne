//
//  FootprintViewModelTests.swift
//  Cerne
//
//  Created by Andrei Rech on 01/10/25.
//

import Foundation
import Testing
@testable import Cerne
import UIKit
import CloudKit

struct FootprintViewModelTests {
    @Test("Inicialização: Deve configurar seleções padrão corretamente")
    func initialization_shouldSetDefaultSelections() {
        let mockRepository = MockFootprintRepository()
        let viewModel = FootprintViewModel(repository: mockRepository)

        #expect(viewModel.currentPage == 1)
        #expect(viewModel.selections.count == CarbonEmittersEnum.allCases.count)
        
        for emitter in CarbonEmittersEnum.allCases {
            #expect(viewModel.selections[emitter] == "Selecionar")
        }
    }
    
    @Test("Busca de Dados: Falha não deve atualizar as seleções")
    func fetchData_failure_shouldNotUpdateSelections() async throws {
        // Arrange
        let mockRepository = MockFootprintRepository()
        mockRepository.shouldFail = true
        let viewModel = FootprintViewModel(repository: mockRepository)
        
        // Act
        await viewModel.fetchData()
        
        // Assert
        #expect(!viewModel.isLoading)
        #expect(viewModel.selections[.car] == "Selecionar")
    }

    @Test("isAbleToSave: Deve ser verdadeiro quando todas as questões são respondidas")
    func isAbleToSave_whenAllQuestionsAnswered_shouldBeTrue() {
        // Arrange
        let viewModel = FootprintViewModel(repository: MockFootprintRepository())
        for emitter in CarbonEmittersEnum.allCases {
            viewModel.updateSelection(for: emitter, to: "Qualquer Valor Válido")
        }
        
        // Assert
        #expect(viewModel.isAbleToSave)
    }
    
    @Test("isAbleToSave: Deve ser falso quando algumas questões não são respondidas")
    func isAbleToSave_whenSomeQuestionsAreNotAnswered_shouldBeFalse() {
        // Arrange
        let viewModel = FootprintViewModel(repository: MockFootprintRepository())
        viewModel.updateSelection(for: .car, to: "Carro")

        // Assert
        #expect(!viewModel.isAbleToSave)
    }

    @Test("Salvar Footprint: Sucesso deve chamar repositório e mostrar alerta")
    func saveFootprint_success_shouldCallRepositoryAndShowAlert() async throws {
        // Arrange
        let mockRepository = MockFootprintRepository()
        let user = User(id: "user1", name: "Test User", height: 1.80)
        mockRepository.mockUserService.users = [user]
        let viewModel = FootprintViewModel(repository: mockRepository)
        
        await viewModel.fetchData()
        
        for emitter in CarbonEmittersEnum.allCases {
            viewModel.updateSelection(for: emitter, to: "Valor")
        }
        #expect(viewModel.isAbleToSave)
        
        // Act
        await viewModel.saveFootprint()
        
        // Assert
        #expect(mockRepository.saveFootprintCalled)
    }
    
    @Test("Salvar Footprint: Não deve chamar repositório se não for possível salvar")
    func saveFootprint_whenNotAbleToSave_shouldNotCallRepository() async throws {
        // Arrange
        let mockRepository = MockFootprintRepository()
        let viewModel = FootprintViewModel(repository: mockRepository)
        #expect(!viewModel.isAbleToSave) // Pré-condição
        
        // Act
        await viewModel.saveFootprint()
        
        // Assert
        #expect(!mockRepository.saveFootprintCalled)
        #expect(!viewModel.showConludedAlert)
    }
}

extension MockFootprintService {
    private static var _getQuestionsResult: [Question]?
    
    var getQuestionsResult: [Question]? {
        get { MockFootprintService._getQuestionsResult }
        set { MockFootprintService._getQuestionsResult = newValue }
    }
}
