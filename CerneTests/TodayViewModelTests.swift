//
//  TodayViewModelTests.swift
//  CerneTests
//
//  Created by Andrei Rech on 01/10/25.
//

import Testing
import Foundation
import CloudKit
@testable import Cerne
import UIKit

@Suite("TodayViewModel Tests")
struct TodayViewModelTests {
    
    var viewModel: TodayViewModel!
    var mockRepository: MockTodayRepository!
    
    let testUser: User
    let otherUser: User
    let tree1: ScannedTree
    let tree2: ScannedTree
    let tree3: ScannedTree
    let pinUser1: Pin
    let pinUser2: Pin
    let pinOtherUser: Pin
    let userFootprint: Footprint
    let userID1: CKRecord.ID
    let userID2: CKRecord.ID

    init() {
        mockRepository = MockTodayRepository()
        viewModel = TodayViewModel(repository: mockRepository)

        testUser = User(id: "user-123", name: "Maria", height: 1.65)
        otherUser = User(id: "user-456", name: "João", height: 1.80)
        
        tree1 = ScannedTree(id: UUID(), species: "Ipê Amarelo", height: 10, dap: 20, totalCO2: 1500.0)
        tree2 = ScannedTree(id: UUID(), species: "Pau-Brasil", height: 12, dap: 25, totalCO2: 2200.0)
        tree3 = ScannedTree(id: UUID(), species: "Ipê Amarelo", height: 8, dap: 18, totalCO2: 1100.0)


        userID1 = CKRecord.ID()
        userID2 = CKRecord.ID()
        
        pinUser1 = Pin(id: UUID(), image: UIImage(), latitude: 0, longitude: 0, date: Date(), userRecordID: userID1, treeRecordID: CKRecord.ID())
        let lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        pinUser2 = Pin(id: UUID(), image: UIImage(), latitude: 0, longitude: 0, date: lastMonthDate, userRecordID: userID1, treeRecordID: CKRecord.ID())
        pinOtherUser = Pin(id: UUID(), image: UIImage(), latitude: 0, longitude: 0, date: Date(), userRecordID: userID2, treeRecordID: CKRecord.ID())
        userFootprint = Footprint(id: UUID(), total: 12000, userRecordID: userID1)
    }
    
    
    @Test("Initial state is correct")
    func testInitialState() {
        #expect(viewModel.userPins.isEmpty)
        #expect(viewModel.allPins.isEmpty)
        #expect(viewModel.userName.isEmpty)
        #expect(viewModel.userFootprint == nil)
        #expect(viewModel.totalCO2 == "0")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.monthlyObjective == 0)
    }

    @Test("fetchData successfully updates all properties")
    @MainActor
    func testFetchDataSuccess() async {
        let allTestPins = [pinUser1, pinUser2, pinOtherUser]
        let allTestTrees = [tree1, tree2, tree3]
        let dto = TodayDTO(currentUser: testUser, allPins: allTestPins, allTrees: allTestTrees, userFootprint: userFootprint)
        mockRepository.mockTodayDTO = dto
        
        await viewModel.fetchData()
        
        #expect(viewModel.isLoading == false, "isLoading should be false after fetch")
        #expect(viewModel.userName == "Maria", "Username should be updated")
        #expect(viewModel.allPins.count == 3, "Should contain all pins from the repository")
        #expect(viewModel.monthlyObjective == 1000, "Monthly objective should be total/12")
    }
    
    @Test("fetchData with no footprint sets objective to zero")
    @MainActor
    func testFetchDataNoFootprint() async {
        let dto = TodayDTO(currentUser: testUser, allPins: [], allTrees: [], userFootprint: nil)
        mockRepository.mockTodayDTO = dto
        
        // Act
        await viewModel.fetchData()
        
        // Assert
        #expect(viewModel.monthlyObjective == 0)
        #expect(viewModel.percentageCO2User() == 0)
    }
    
    @Test("fetchData on failure does not change properties")
    @MainActor
    func testFetchDataFailure() async {
        // Arrange
        mockRepository.shouldFail = true
        
        // Act
        await viewModel.fetchData()
        
        // Assert
        #expect(viewModel.isLoading == false, "isLoading should be false after failed fetch")
        #expect(viewModel.userName.isEmpty, "Username should remain empty")
        #expect(viewModel.allPins.isEmpty, "Pins should remain empty")
    }
}
