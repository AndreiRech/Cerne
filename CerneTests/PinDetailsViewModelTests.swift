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
import UIKit
import CloudKit

struct PinDetailsViewModelTests {
    // MARK: - Setup
    func setupTestEnvironment(shouldServiceFail: Bool = false) -> (viewModel: PinDetailsViewModel, mockPinService: MockPinService) {
        let testPin = Pin(image: UIImage(), latitude: -23.5, longitude: -46.6, date: Date(), userRecordID: CKRecord.ID(), treeRecordID: CKRecord.ID())
        
        let matchingDetails = TreeDetails(
            commonName: "Ipê-amarelo",
            scientificName: "Handroanthus albus (Ipê-Amarelo)",
            density: 1.0,
            description: "texto"
        )
        
        let mockPinService = MockPinService(
            shouldFail: shouldServiceFail
        )
        
        mockPinService.pins.append(testPin)
        mockPinService.details = [matchingDetails]
        
        let viewModel = PinDetailsViewModel(pin: testPin, pinService: mockPinService, userService: MockUserService(), userDefaultService: MockUserDefaultService(), treeService: ScannedTreeService())
        
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
    @Test func shouldDeletePin() async {
        // Given
        let (viewModel, mockPinService) = setupTestEnvironment()
        
        // When
        await viewModel.deletePin()
        
        // Then
        #expect(mockPinService.pins.isEmpty)
    }
    
    @Test func shouldDeletePinFail() async {
        // Given
        let (viewModel, mockPinService) = setupTestEnvironment(shouldServiceFail: true)
        
        #expect(mockPinService.pins.count == 1)
        
        // When
        await viewModel.deletePin()
        
        // Then
        #expect(mockPinService.pins.count == 1)
    }
    
    // MARK: - Testes da Função `reportPin`
    @Test func shouldReportPin() async {
        // Given
        let (viewModel, mockPinService) = setupTestEnvironment()
        let initialReportCount = viewModel.pin.reports
        
        #expect(initialReportCount == 0)
        
        // When
        await viewModel.reportPin()
        
        // Then
        #expect(mockPinService.pins.first?.reports == initialReportCount + 1)
    }
    
    @Test func shouldReportPinFail() async {
        // Given
        let (viewModel, mockPinService) = setupTestEnvironment(shouldServiceFail: true)
        let initialReportCount = viewModel.pin.reports
        
        #expect(initialReportCount == 0)
        
        // When
        await viewModel.reportPin()
        
        // Then
        #expect(mockPinService.pins.first?.reports == initialReportCount)
    }
}
