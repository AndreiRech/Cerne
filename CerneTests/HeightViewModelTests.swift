//
//  HeightViewModelTests.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import Foundation
import Testing
@testable import Cerne
import UIKit

struct HeightViewModelTests {
    @Test func shouldStartSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockMotionService = MockMotionService()
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let measureDiameter: Double = 0.8
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            motionService: mockMotionService,
            userHeight: userHeight,
            distanceToTree: distanceToTree,
            measuredDiameter: measureDiameter,
            treeImage: UIImage(),
            userLatitude: 0.0,
            userLongitude: 0.0
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
        let mockMotionService = MockMotionService()
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let measureDiameter: Double = 0.8
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            motionService: mockMotionService,
            userHeight: userHeight,
            distanceToTree: distanceToTree,
            measuredDiameter: measureDiameter,
            treeImage: UIImage(),
            userLatitude: 0.0,
            userLongitude: 0.0
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
        let mockMotionService = MockMotionService()
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let measureDiameter: Double = 0.8
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            motionService: mockMotionService,
            userHeight: userHeight,
            distanceToTree: distanceToTree,
            measuredDiameter: measureDiameter,
            treeImage: UIImage(),
            userLatitude: 0.0,
            userLongitude: 0.0
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
        let mockMotionService = MockMotionService()
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let measureDiameter: Double = 0.8
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            motionService: mockMotionService,
            userHeight: userHeight,
            distanceToTree: distanceToTree,
            measuredDiameter: measureDiameter,
            treeImage: UIImage(),
            userLatitude: 0.0,
            userLongitude: 0.0
        )
        
        // When
        _ = viewModel.previewLayer
        
        // Then
        #expect(mockCameraService.wasCalled)
        #expect(mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == nil)
    }
    
    @Test func shouldCalculateCorrectHeightDegreeChangeUp() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockMotionService = MockMotionService(angleInDegrees: 100)
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let measureDiameter: Double = 0.8
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            motionService: mockMotionService,
            userHeight: userHeight,
            distanceToTree: distanceToTree,
            measuredDiameter: measureDiameter,
            treeImage: UIImage(),
            userLatitude: 0.0,
            userLongitude: 0.0
        )
        
        // When
        viewModel.calculateHeight(angleInDegrees: mockMotionService.getCurrentAngle())
        
        // Then
        #expect(viewModel.estimatedHeight != userHeight)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func shouldCalculateCorrectHeightDegreeChangeDown() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockMotionService = MockMotionService(angleInDegrees: 80)
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let measureDiameter: Double = 0.8
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            motionService: mockMotionService,
            userHeight: userHeight,
            distanceToTree: distanceToTree,
            measuredDiameter: measureDiameter,
            treeImage: UIImage(),
            userLatitude: 0.0,
            userLongitude: 0.0
        )
        
        // When
        viewModel.calculateHeight(angleInDegrees: mockMotionService.getCurrentAngle())
        
        // Then
        #expect(viewModel.estimatedHeight != userHeight)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func shouldCalculateCorrectHeightNoDegreeChange() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockMotionService = MockMotionService(angleInDegrees: 90)
        let userHeight: Double = 1.80
        let distanceToTree: Double = 5.0
        let measureDiameter: Double = 0.8
        let viewModel = HeightViewModel(
            cameraService: mockCameraService,
            motionService: mockMotionService,
            userHeight: userHeight,
            distanceToTree: distanceToTree,
            measuredDiameter: measureDiameter,
            treeImage: UIImage(),
            userLatitude: 0.0,
            userLongitude: 0.0
        )
        
        // When
        viewModel.calculateHeight(angleInDegrees: mockMotionService.getCurrentAngle())
        
        // Then
        #expect(viewModel.estimatedHeight == userHeight)
        #expect(mockCameraService.errorMessage == nil)
    }
}
