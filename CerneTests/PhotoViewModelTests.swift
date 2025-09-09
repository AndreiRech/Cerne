//
//  PhotoViewModelTests.swift
//  Cerne
//
//  Created by Andrei Rech on 09/09/25.
//

import Foundation
import Testing
@testable import Cerne

struct PhotoViewModelTests {
    @Test func shouldStartSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService
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
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService
        )
        
        // When
        let request = await mockCameraService.requestPermissions()
        
        viewModel.onAppear()
        await Task.yield()
        
        // Then
        #expect(!request)
        #expect(mockCameraService.wasCalled)
        #expect(!mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage != nil)
    }
    
    @Test func shouldStopSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService
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
    
    @Test func shouldTakePhoto() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService
        )
        
        // When
        viewModel.onAppear()
        await Task.yield()
        
        viewModel.capturePhoto()
        
        // Then
        #expect(mockCameraService.wasCalled)
        #expect(mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == nil)
        #expect(mockCameraService.message == "Captured")
    }
    
    @Test func shouldRetakePhoto() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService
        )
        
        // When
        viewModel.onAppear()
        await Task.yield()
        
        viewModel.retakePhoto()
        
        // Then
        #expect(mockCameraService.wasCalled)
        #expect(mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == nil)
        #expect(mockCameraService.message == "Cleared")
    }
}
