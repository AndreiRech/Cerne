//
//  OnboardingViewModelTests.swift
//  CerneTests
//
//  Created by Andrei Rech on 01/10/25.
//

import Testing
@testable import Cerne // Importe o módulo do seu app com @testable

@Suite("OnboardingViewModel Tests")
struct OnboardingViewModelTests {
    @Test("Initial State")
    func testInitialState() {
        let mockUserDefaultService = MockUserDefaultService()
        let mockUserService = MockUserService()
        let viewModel = OnboardingViewModel(userDefaultService: mockUserDefaultService, userService: mockUserService)
        
        #expect(viewModel.isCreatingUser == false, "isCreatingUser should be false initially")
        #expect(viewModel.username.isEmpty, "username should be empty initially")
        #expect(viewModel.height.isEmpty, "height should be empty initially")
        #expect(viewModel.errorMessage == nil, "errorMessage should be nil initially")
        #expect(viewModel.currentPageIndex == 0, "currentPageIndex should be 0 initially")
        #expect(viewModel.onboardingPages.count == 3, "There should be exactly 3 onboarding pages")
    }

    @Test("finishOnboarding() sets isCreatingUser to true")
    func testFinishOnboarding() {
        let mockUserDefaultService = MockUserDefaultService()
        let mockUserService = MockUserService()
        let viewModel = OnboardingViewModel(userDefaultService: mockUserDefaultService, userService: mockUserService)
        
        viewModel.finishOnboarding()
        
        #expect(viewModel.isCreatingUser == true, "isCreatingUser should be true after calling finishOnboarding")
    }
    
    @Test("saveUser() with valid data succeeds")
    func testSaveUserSuccess() async {
        let mockUserDefaultService = MockUserDefaultService()
        let mockUserService = MockUserService()
        let viewModel = OnboardingViewModel(userDefaultService: mockUserDefaultService, userService: mockUserService)
        
        viewModel.username = "Default User"
        viewModel.height = "1.75"
        
        await viewModel.saveUser()
        
        #expect(viewModel.errorMessage == nil, "errorMessage should be nil on success")
        #expect(mockUserDefaultService.isOnboardingDone(), "Onboarding should be marked as done on success")
        
        let createdUser = try? await mockUserService.fetchUsers().first
        #expect(createdUser != nil, "A user should have been created")
        #expect(createdUser?.name == "Default User")
        #expect(createdUser?.height == 1.75)
    }
    
    @Test("saveUser() with invalid height string uses default height")
    func testSaveUserWithInvalidHeightString() async {
        let mockUserDefaultService = MockUserDefaultService()
        let mockUserService = MockUserService()
        let viewModel = OnboardingViewModel(userDefaultService: mockUserDefaultService, userService: mockUserService)
        
        viewModel.username = "Default Height User"
        viewModel.height = "not a number"
        
        await viewModel.saveUser()
        
        #expect(viewModel.errorMessage == nil, "errorMessage should be nil")
        #expect(mockUserDefaultService.isOnboardingDone(), "Onboarding should be marked as done")
        
        let createdUser = try? await mockUserService.fetchUsers().first
        #expect(createdUser?.height == 1.75)
    }

    @Test("saveUser() with generic service error fails and sets error message")
    func testSaveUserFailsWithGenericError() async {
        let mockUserDefaultService = MockUserDefaultService()
        let mockUserService = MockUserService()
        let viewModel = OnboardingViewModel(userDefaultService: mockUserDefaultService, userService: mockUserService)
        
        mockUserService.shouldFail = true
        viewModel.username = "Test User"
        viewModel.height = "1.75"
        
        await viewModel.saveUser()
        
        #expect(viewModel.errorMessage != nil, "errorMessage should not be nil")
        #expect(viewModel.errorMessage == "Ocorreu um erro inesperado. Tente novamente.", "Error message should be the generic one")
        #expect(!mockUserDefaultService.isOnboardingDone(), "Onboarding should NOT be marked as done on failure")
    }
}

