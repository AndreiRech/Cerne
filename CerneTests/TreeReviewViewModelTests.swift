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


struct TreeReviewViewModelTests {
    @Test func shouldCreateScannedTree() async {
        //Given
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false, isNetworkError: false)
        let mockScannedTreeService = MockScannedTreeService(shouldFail: false)
        let mockPinService = MockPinService(shouldFail: false)
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockTreeDataService = MockTreeDataService()
        
        let viewModel = TreeReviewViewModel(
            cameraService: mockCameraService,
            scannedTreeService: mockScannedTreeService,
            treeAPIService: mockTreeAPIService,
            pinService: mockPinService,
            treeDataService: mockTreeDataService,
            userService: MockUserService(),
            measuredDiameter: 40.0,
            treeImage:  UIImage(named: "TreeTest"),
            estimatedHeight: 5.0,
            pinLatitude: -30.0,
            pinLongitude: -51.0
        )
        
        //When
        await viewModel.createScannedTree()
        
        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.tree != nil)
    }
    
    @Test func shouldNotCreatScannedTree() async {
        //Given
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false, isNetworkError: false)
        let mockScannedTreeService = MockScannedTreeService(shouldFail: true)
        let mockPinService = MockPinService(shouldFail: false)
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockTreeDataService = MockTreeDataService()
        
        let viewModel = TreeReviewViewModel(
            cameraService: mockCameraService,
            scannedTreeService: mockScannedTreeService,
            treeAPIService: mockTreeAPIService,
            pinService: mockPinService,
            treeDataService: mockTreeDataService,
            userService: MockUserService(),
            measuredDiameter: 40.0,
            treeImage: UIImage(),
            estimatedHeight: 5.0,
            pinLatitude: -30.0,
            pinLongitude: -51.0
        )
        
        //When
        await viewModel.createScannedTree()
        
        // Then
        #expect(viewModel.isLoading == false)
        #expect(viewModel.tree == nil)
        #expect(viewModel.errorMessage != nil)
    }
    
    @Test func shouldNotCreatScannedTreeWithoutImage() async {
        //Given
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false, isNetworkError: false)
        let mockScannedTreeService = MockScannedTreeService(shouldFail: true)
        let mockPinService = MockPinService(shouldFail: false)
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockTreeDataService = MockTreeDataService()

        
        let viewModel = TreeReviewViewModel(
            cameraService: mockCameraService,
            scannedTreeService: mockScannedTreeService,
            treeAPIService: mockTreeAPIService,
            pinService: mockPinService,
            treeDataService: mockTreeDataService,
            userService: MockUserService(),
            measuredDiameter: 40.0,
            treeImage: nil,
            estimatedHeight: 5.0,
            pinLatitude: -30.0,
            pinLongitude: -51.0
        )
        
        // When
        await viewModel.createScannedTree()
        
        // Then
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage == "Nenhuma imagem disponível para identificar.")
    }
    
    @Test func shouldSetErrorMessageWhenCreatePinFails() async {
        // Given
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false, isNetworkError: false)
        let mockScannedTreeService = MockScannedTreeService(shouldFail: false)
        let mockPinService = MockPinService(shouldFail: true)
        let mockTreeDataService = MockTreeDataService()

        
        let viewModel = TreeReviewViewModel(
            cameraService: MockCameraService(shouldFail: false),
            scannedTreeService: mockScannedTreeService,
            treeAPIService: mockTreeAPIService,
            pinService: mockPinService,
            treeDataService: mockTreeDataService,
            userService: MockUserService(),
            measuredDiameter: 40.0,
            treeImage: UIImage(),
            estimatedHeight: 5.0,
            pinLatitude: -30.0,
            pinLongitude: -51.0
        )
        
        // When
        await viewModel.createScannedTree()
        
        // Then
        let expectedErrorMessage = "Não foi possível criar o pin. Faltam dados da árvore ou da imagem."
        #expect(viewModel.isLoading == false)
        #expect(viewModel.tree != nil)
        #expect(viewModel.errorMessage == expectedErrorMessage)
    }
    
    
    @Test func shouldUpdateScannedTree() async throws {
        // Given
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false)
        let mockScannedTreeService = MockScannedTreeService(shouldFail: false)
        let mockPinService = MockPinService(shouldFail: true)
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockTreeDataService = MockTreeDataService()
        
        let viewModel = TreeReviewViewModel(
            cameraService: mockCameraService,
            scannedTreeService: mockScannedTreeService,
            treeAPIService: mockTreeAPIService,
            pinService: mockPinService,
            treeDataService: mockTreeDataService,
            userService: MockUserService(),
            measuredDiameter: 40.0,
            treeImage: UIImage(named: "TreeTest"),
            estimatedHeight: 5.0,
            pinLatitude: -30.0,
            pinLongitude: -51.0
        )
        
        await viewModel.createScannedTree()
        #expect(viewModel.tree != nil)
        
        viewModel.updateSpecies = "Pau-Brasil"
        viewModel.updateHeight = 15.0
        viewModel.updateDap = 55.0
        
        // When
        await viewModel.updateScannedTree()
        
        // Then
        #expect(viewModel.isLoading == false)
        let updatedTree = try #require(viewModel.tree)
        #expect(updatedTree.species == "Pau-Brasil")
        #expect(updatedTree.height == 15.0)
        #expect(updatedTree.dap == 55.0)
    }
    
    @Test func shouldCancel() async {
        // Given
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false, isNetworkError: false)
        let mockScannedTreeService = MockScannedTreeService(shouldFail: false)
        let mockPinService = MockPinService(shouldFail: false)
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockTreeDataService = MockTreeDataService()

        
        let viewModel = TreeReviewViewModel(
            cameraService: mockCameraService,
            scannedTreeService: mockScannedTreeService,
            treeAPIService: mockTreeAPIService,
            pinService: mockPinService,
            treeDataService: mockTreeDataService,
            userService: MockUserService(),
            measuredDiameter: 15.0,
            treeImage: UIImage(),
            estimatedHeight: 20.0,
            pinLatitude: -30.0,
            pinLongitude: -51.0
        )
        
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
