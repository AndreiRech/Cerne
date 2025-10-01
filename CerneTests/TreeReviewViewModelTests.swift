//
//  TreeReviewViewModelTests.swift
//  CerneTests
//
//  Created by Maria Santellano on 15/09/25.
//

import Foundation
import Testing
import UIKit
@testable import Cerne
import CloudKit

@MainActor
struct TreeReviewViewModelTests {
    
    // --- Testes de Criação ---

    @Test("shouldCreateTreeAndPinSuccessfully")
    func shouldCreateTreeAndPinSuccessfully() async {
        // Given
        let mockRepository = MockTreeReviewRepository()
        // Configure o mock para o cenário de sucesso
        let initialTree = ScannedTree(species: "Ipê", height: 5.0, dap: 40.0, totalCO2: 120.0)
        let associatedPin = Pin(image: UIImage(), latitude: -30, longitude: -51, date: Date(), userRecordID: CKRecord.ID(), treeRecordID: CKRecord.ID())
        mockRepository.mockCreatedTree = initialTree
        mockRepository.mockCreatedPin = associatedPin
        
        let viewModel = TreeReviewViewModel(
            repository: mockRepository,
            measuredDiameter: 40.0,
            treeImage: UIImage(),
            estimatedHeight: 5.0,
            pinLatitude: -30.0,
            pinLongitude: -51.0,
            treeSpecies: "Ipê"
        )
        
        // When
        await viewModel.createScannedTree()
        
        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil) // Não deve haver erro no sucesso
        #expect(viewModel.tree != nil) // A árvore foi criada
        #expect(viewModel.tree?.species == "Ipê")
    }
    
    @Test("shouldSetErrorMessageWhenCreationFails")
    func shouldSetErrorMessageWhenCreationFails() async {
        // Given
        let mockRepository = MockTreeReviewRepository()
        // Configure o mock para o cenário de falha
        mockRepository.shouldFail = true
        
        let viewModel = TreeReviewViewModel(
            repository: mockRepository,
            measuredDiameter: 40.0,
            treeImage: UIImage(),
            estimatedHeight: 5.0,
            pinLatitude: -30.0,
            pinLongitude: -51.0,
            treeSpecies: "Qualquer"
        )
        
        // When
        await viewModel.createScannedTree()
        
        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.tree == nil) // A árvore não deve ser criada
        #expect(viewModel.errorMessage != nil) // A mensagem de erro deve ser definida
        #expect(viewModel.errorMessage == "Ocorreu um erro ao criar a árvore: The operation couldn’t be completed. (Cerne.GenericError error 1.)")
    }

    // --- Testes de Atualização ---
    
    @Test("shouldUpdateScannedTreeSuccessfully")
    func shouldUpdateScannedTreeSuccessfully() async throws {
        // Given
        let mockRepository = MockTreeReviewRepository()
        let initialTree = ScannedTree(species: "Ipê", height: 5.0, dap: 40.0, totalCO2: 120.0)
        // O mock deve primeiro "criar" a árvore para que ela exista no ViewModel
        mockRepository.mockCreatedTree = initialTree
        mockRepository.mockCreatedPin = Pin(image: UIImage(), latitude: 0, longitude: 0, date: Date(), userRecordID: CKRecord.ID(), treeRecordID: CKRecord.ID())
        
        let viewModel = TreeReviewViewModel(repository: mockRepository, measuredDiameter: 40, treeImage: UIImage(), estimatedHeight: 5, pinLatitude: 0, pinLongitude: 0, treeSpecies: "Ipê")

        // Primeiro, crie a árvore para ter um estado inicial
        await viewModel.createScannedTree()
        #expect(viewModel.tree != nil)
        
        // Agora, configure o mock para a operação de atualização
        let updatedTreeData = ScannedTree(species: "Pau-Brasil", height: 15.0, dap: 55.0, totalCO2: 250.0)
        mockRepository.mockUpdatedTree = updatedTreeData
        
        // Defina os novos valores no ViewModel
        viewModel.updateSpecies = "Pau-Brasil"
        viewModel.updateHeight = 15.0
        viewModel.updateDap = 55.0
        
        // When
        await viewModel.updateScannedTree()
        
        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        let finalTree = try #require(viewModel.tree) // Garante que a árvore não é nula
        #expect(finalTree.species == "Pau-Brasil")
        #expect(finalTree.height == 15.0)
        #expect(finalTree.dap == 55.0)
    }

    // --- Teste de Lógica Interna (não precisa de mock) ---

    @Test("shouldCancelAndResetState")
    func shouldCancelAndResetState() {
        // Given
        let mockRepository = MockTreeReviewRepository() // Mesmo não sendo usado, é necessário para inicializar
        let viewModel = TreeReviewViewModel(repository: mockRepository, measuredDiameter: 0, treeImage: nil, estimatedHeight: 0, pinLatitude: 0, pinLongitude: 0, treeSpecies: "")
        
        // Modifica o estado
        viewModel.isLoading = true
        viewModel.errorMessage = "Erro antigo"
        viewModel.updateSpecies = "Alguma espécie"
        viewModel.tree = ScannedTree(species: "A", height: 1, dap: 1, totalCO2: 1)
        
        // When
        viewModel.cancel()
        
        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.updateSpecies.isEmpty)
        #expect(viewModel.updateHeight == 0.0)
        #expect(viewModel.updateDap == 0.0)
        #expect(viewModel.tree == nil)
    }
}
