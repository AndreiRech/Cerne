//
//  PhotoViewModelTests.swift
//  Cerne
//
//  Created by Andrei Rech on 09/09/25.
//

import Foundation
import Testing
@testable import Cerne
import UIKit

struct PhotoViewModelTests {
    @Test func shouldStartSession() async {
        // Given
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService,
            treeAPIService: mockTreeAPIService
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
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService,
            treeAPIService: mockTreeAPIService
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
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService,
            treeAPIService: mockTreeAPIService
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
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService,
            treeAPIService: mockTreeAPIService
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
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService,
            treeAPIService: mockTreeAPIService
        )
        
        // When
        viewModel.onAppear()
        
        
        viewModel.retakePhoto()
        
        // Then
        #expect(mockCameraService.wasCalled)
        #expect(mockCameraService.isCorrect)
        #expect(mockCameraService.errorMessage == nil)
        #expect(mockCameraService.message == "Cleared")
    }
    
    @Test func shouldIdentifyTree() async {
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockTreeAPIService = MockTreeAPIService(shouldFail: false)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService,
            treeAPIService: mockTreeAPIService
        )
        
        // When
        await viewModel.identifyTree(image: UIImage())
//        try? await Task.sleep(for: .seconds(2))

        // Then
        #expect(mockTreeAPIService.isCorret)
        #expect(viewModel.identifiedTree?.bestMatch == "value")
    }
    
    @Test func shouldFailNetworkErrorIdentifyTree() async {
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockTreeAPIService = MockTreeAPIService(shouldFail: true, isNetworkError: true)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService,
            treeAPIService: mockTreeAPIService
        )
        
        // When
        await viewModel.identifyTree(image: UIImage())
//        await Task.yield()

        // Then
        #expect(!mockTreeAPIService.isCorret)
        #expect(viewModel.errorMessage == NetworkError.invalidResponse.errorDescription)
    }
    
    @Test func shouldFailOtherErrorsIdentifyTree() async {
        let mockCameraService = MockCameraService(shouldFail: false)
        let mockTreeAPIService = MockTreeAPIService(shouldFail: true)
        let viewModel = PhotoViewModel(
            cameraService: mockCameraService,
            treeAPIService: mockTreeAPIService
        )
        
        // When
        await viewModel.identifyTree(image: UIImage())
        await Task.yield()

        // Then
        #expect(!mockTreeAPIService.isCorret)
        #expect(viewModel.errorMessage != nil)
    }
}
