//
//  HeightViewModelTests.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import Foundation
import Testing
@testable import Cerne

struct HeightViewModelTests {
    @Test func shouldStartSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            userHeight: userHeight,
            distanceToTree: distanceToTree
        )
        
        // When
        let request = await mockCameraService.requestPermissions()
        
        viewModel.onAppear()
        await Task.yield()
        
        // Then
        #expect(request)
        #expect(mockCameraService.wasCalled)
        #expect(mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == nil)
    }
    
    @Test func shouldFailStartSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: true)
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            userHeight: userHeight,
            distanceToTree: distanceToTree
        )
        
        // When
        let request = await mockCameraService.requestPermissions()
        
        viewModel.onAppear()
        await Task.yield()
        
        // Then
        #expect(!request)
        #expect(mockCameraService.wasCalled)
        #expect(!mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == "Erro")
    }
    
    @Test func shouldStopSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            userHeight: userHeight,
            distanceToTree: distanceToTree
        )
        
        // When
        let request = await mockCameraService.requestPermissions()
        
        viewModel.onAppear()
        await Task.yield()
        
        viewModel.onDisappear()
        
        // Then
        #expect(request)
        #expect(mockCameraService.wasCalled)
        #expect(mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == nil)
    }
    
    @Test func shouldGetLayer() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            userHeight: userHeight,
            distanceToTree: distanceToTree
        )
        
        // When
        _ = viewModel.previewLayer
        
        // Then
        #expect(mockCameraService.wasCalled)
        #expect(mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == nil)
    }
    
    @Test func shouldCalculateCorrectHeightDegreeChange() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            userHeight: userHeight,
            distanceToTree: distanceToTree
        )
        
        // When
        viewModel.calculateHeight(angleInDegrees: 100)
        
        // Then
        #expect(viewModel.estimatedHeight != userHeight)
        #expect(viewModel.errorMessage == nil)
        
        // When
        viewModel.calculateHeight(angleInDegrees: 80)
        
        // Then
        #expect(viewModel.estimatedHeight != userHeight)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func shouldCalculateCorrectHeightNoDegreeChange() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            userHeight: userHeight,
            distanceToTree: distanceToTree
        )
        
        // When
        viewModel.calculateHeight(angleInDegrees: 90)
        
        // Then
        #expect(viewModel.estimatedHeight == userHeight)
        #expect(mockCameraService.errorMessage == nil)
    }
}
