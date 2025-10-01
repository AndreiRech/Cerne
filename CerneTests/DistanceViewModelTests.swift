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
            userDefaultService: MockUserDefaultService(),
            userHeight: 0.0,
            measuredDiameter: 0.0,
            treeImage: UIImage(),
            treeSpecies: ""
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
            userDefaultService: MockUserDefaultService(),
            userHeight: 0.0,
            measuredDiameter: 0.0,
            treeImage: UIImage(),
            treeSpecies: ""
        )
        
        // When
        viewModel.onAppear()
        viewModel.onDisappear()
        
        // Then
        #expect(mockARService.isCorrect)
    }
}
