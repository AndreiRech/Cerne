//
//  PinDetailsViewModelTests.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 15/09/25.
//

import Foundation
import Testing
@testable import Cerne
import SwiftData

struct PinDetailsViewModelTests {
    // MARK: - Setup
    func setupTestEnvironment(shouldServiceFail: Bool = false) -> (viewModel: PinDetailsViewModel, mockPinService: MockPinService) {
        
        let testUser = User(name: "Test User", height: 1.80)
        let testTree = ScannedTree(species: "Ipê-Amarelo", height: 12.0, dap: 0.7, totalCO2: 150.0)
        let testPin = Pin(image: Data(), latitude: -23.5, longitude: -46.6, date: Date(), user: testUser, tree: testTree)
        
        let matchingDetails = TreeDetails(
            commonName: "Ipê-amarelo",
            scientificName: "Handroanthus albus (Ipê-Amarelo)",
            density: 1.0,
            description: "texto"
        )
        
        let mockPinService = MockPinService(
            shouldFail: shouldServiceFail,
            details: [matchingDetails]
        )
        
        mockPinService.pins.append(testPin)
        
        let viewModel = PinDetailsViewModel(pin: testPin, pinService: mockPinService)
        
        return (viewModel, mockPinService)
    }
    
    // MARK: - Testes de Inicialização (Setup)
    @Test func should_fetch_details_on_init_and_succeed() {
        // Given
        let (viewModel, _) = setupTestEnvironment(shouldServiceFail: false)
        
        // Then
        #expect(viewModel.details != nil)
        #expect(viewModel.details?.commonName == "Ipê-amarelo")
    }
    
    @Test func shouldFetchFetailsOnInitFail() {
        // Given
        let (viewModel, _) = setupTestEnvironment(shouldServiceFail: true)
        
        // Then
        #expect(viewModel.details == nil)
    }

    // MARK: - Testes da Função `deletePin`
    @Test func shouldDeletePin() {
        // Given
        let (viewModel, mockPinService) = setupTestEnvironment()
        
        // When
        viewModel.deletePin(pin: viewModel.pin)
        
        // Then
        #expect(mockPinService.pins.isEmpty)
    }
    
    @Test func shouldDeletePinFail() {
        // Given
        let (viewModel, mockPinService) = setupTestEnvironment(shouldServiceFail: true)
        
        #expect(mockPinService.pins.count == 1)
        
        // When
        viewModel.deletePin(pin: viewModel.pin)
        
        // Then
        #expect(mockPinService.pins.count == 1)
    }
    
    // MARK: - Testes da Função `reportPin`
    @Test func shouldReportPin() {
        // Given
        let (viewModel, mockPinService) = setupTestEnvironment()
        let initialReportCount = viewModel.pin.reports
        
        #expect(initialReportCount == 0)
        
        // When
        viewModel.reportPin(to: viewModel.pin)
        
        // Then
        #expect(mockPinService.pins.first?.reports == initialReportCount + 1)
    }
    
    @Test func shouldReportPinFail() {
        // Given
        let (viewModel, mockPinService) = setupTestEnvironment(shouldServiceFail: true)
        let initialReportCount = viewModel.pin.reports
        
        #expect(initialReportCount == 0)
        
        // When
        viewModel.reportPin(to: viewModel.pin)
        
        // Then
        #expect(mockPinService.pins.first?.reports == initialReportCount)
    }
    
    // MARK: - Testes da Função `isPinFromUser`
    @Test func shouldCheckIfPinIsFromUser() {
        // Given
        let (viewModel, _) = setupTestEnvironment()
        
        // When
        let isFromUser = viewModel.isPinFromUser()
        
        // Then
        #expect(isFromUser == false)
    }
}
