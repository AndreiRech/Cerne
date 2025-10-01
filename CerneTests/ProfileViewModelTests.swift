//
//  ProfileViewModelTests.swift
//  CerneTests
//
//  Created by Andrei Rech on 01/10/25.
//

import Testing
import Foundation
import CloudKit
import UIKit // Necessário para UIImage no Pin
@testable import Cerne

@MainActor
struct ProfileViewModelTests {
    let testUser: User
    let testPins: [Pin]
    let testTrees: [ScannedTree]
    let testFootprint: Footprint

    init() {
        let userRecordID = CKRecord.ID(recordName: "testUser")
        testUser = User(id: userRecordID.recordName, name: "Test User", height: 1.80)
        
        let tree1RecordID = CKRecord.ID(recordName: "tree1")
        let tree2RecordID = CKRecord.ID(recordName: "tree2")
        
        testTrees = [
            ScannedTree(id: UUID(), species: "Ipê", height: 10, dap: 20, totalCO2: 150),
            ScannedTree(id: UUID(), species: "Araucaria", height: 15, dap: 30, totalCO2: 250)
        ]
        
        let calendar = Calendar.current
        let now = Date()
        let januaryDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: now), month: 1, day: 15))!
        let marchDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: now), month: 3, day: 10))!

        testPins = [
            Pin(id: UUID(), image: UIImage(), latitude: 0, longitude: 0, date: januaryDate, userRecordID: userRecordID, treeRecordID: tree1RecordID),
            Pin(id: UUID(), image: UIImage(), latitude: 0, longitude: 0, date: marchDate, userRecordID: userRecordID, treeRecordID: tree2RecordID)
        ]
        
        testFootprint = Footprint(id: UUID(), total: 1200, userRecordID: userRecordID) // 1200 Kg anuais -> 100 Kg mensais
    }
    
    @Test("fetchData - Success with Footprint")
    func testFetchData_Success_WithFootprint() async {
        let profileData = ProfileDTO(currentUser: testUser, allPins: testPins, allTrees: testTrees, userFootprint: testFootprint)
        let mockRepository = MockProfileRepository(profileData: profileData)
        let viewModel = ProfileViewModel(repository: mockRepository)
        
        await viewModel.fetchData()
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.userName == "Test User")
        #expect(viewModel.footprint == "1200 Kg")
        #expect(viewModel.monthlyObjective == 100) // 1200 / 12
        
        #expect(viewModel.annualData.count == 12)
        #expect(viewModel.annualData[1].normalizedHeight == 0.0) // Fevereiro
    }
    
    @Test("fetchData - Success without Footprint")
    func testFetchData_Success_WithoutFootprint() async {
        let profileData = ProfileDTO(currentUser: testUser, allPins: testPins, allTrees: testTrees, userFootprint: nil)
        let mockRepository = MockProfileRepository(profileData: profileData)
        let viewModel = ProfileViewModel(repository: mockRepository)
        
        await viewModel.fetchData()
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.userName == "Test User")
        #expect(viewModel.footprint == nil)
        #expect(viewModel.monthlyObjective == 0)
        #expect(viewModel.CO2AnualPercent() == 0) // Objetivo anual é 0
        #expect(viewModel.annualData[0].normalizedHeight == 0.0) // Altura normalizada é 0 pois o objetivo é 0
    }

    @Test("fetchData - Failure")
    func testFetchData_Failure() async {
        let mockRepository = MockProfileRepository(shouldFail: true)
        let viewModel = ProfileViewModel(repository: mockRepository)
        
        await viewModel.fetchData()
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.userName == " ") // Valor inicial
        #expect(viewModel.userPins.isEmpty)
        #expect(viewModel.footprint == nil)
    }

    @Test("deleteAccount - Success")
    func testDeleteAccount_Success() async {
        let profileData = ProfileDTO(currentUser: testUser, allPins: [], allTrees: [], userFootprint: nil)
        let mockRepository = MockProfileRepository(profileData: profileData)
        let viewModel = ProfileViewModel(repository: mockRepository)
        await viewModel.fetchData() // Para popular o usuário interno
        
        await viewModel.deleteAccount()
        
        #expect(!viewModel.isLoading)
        #expect(mockRepository.deleteAccountCalled)
    }

    @Test("Notification - User data did update")
    func testUserDataDidUpdateNotification() async throws {
        let profileData = ProfileDTO(currentUser: testUser, allPins: [], allTrees: [], userFootprint: nil)
        let mockRepository = MockProfileRepository(profileData: profileData)
        let viewModel = ProfileViewModel(repository: mockRepository)
        
        #expect(viewModel.userName == " ")
        
        NotificationCenter.default.post(name: .didUpdateUserData, object: nil)
        
        try await Task.sleep(for: .milliseconds(100))

        #expect(viewModel.userName == "Test User")
    }
}
