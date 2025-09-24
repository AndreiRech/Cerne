//
//  DistanceViewModelTests.swift
//  CerneTests
//
//  Created by Andrei Rech on 12/09/25.
//

import Foundation
import Testing
@testable import Cerne
import UIKit

@MainActor
struct DistanceViewModelTests {
    @Test func shouldStartSession() {
        // Given
        let mockARService = MockARService(shouldFail: false)
        let viewModel = DistanceViewModel(
            arService: mockARService,
            userDefaultService: MockUserDefaultService(),
            userHeight: 0.0,
            measuredDiameter: 0.0,
            treeImage: UIImage()
        )
        
        // When
        viewModel.onAppear()
        
        // Then
        #expect(mockARService.isCorrect)
    }
    
    @Test func shouldFinishSession() {
        // Given
        let mockARService = MockARService(shouldFail: false)
        let viewModel = DistanceViewModel(
            arService: mockARService,
            userDefaultService: MockUserDefaultService(),
            userHeight: 0.0,
            measuredDiameter: 0.0,
            treeImage: UIImage()
        )
        
        // When
        viewModel.onAppear()
        viewModel.onDisappear()
        
        // Then
        #expect(mockARService.isCorrect)
    }
    
    @Test func shouldUpdateDistanceTextOnNewValue() async throws {
        // Given
        let mockARService = MockARService()
        let viewModel = DistanceViewModel(
            arService: mockARService,
            userDefaultService: MockUserDefaultService(),
            userHeight: 0.0,
            measuredDiameter: 0.0,
            treeImage: UIImage()
        )
        let inputDistance: Float = 1.2345
        let expectedText = "1.23 longe da arvore"
        
        // When
        mockARService.distancePublisher.send(inputDistance)
        
        try await Task.sleep(nanoseconds: 1_000_000)

        // Then
        #expect(viewModel.distanceText == expectedText)
    }
}
