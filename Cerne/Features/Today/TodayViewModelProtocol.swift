//
//  TodayViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import Foundation
@MainActor

protocol TodayViewModelProtocol {
    var pinService: PinServiceProtocol { get }
    var userService: UserServiceProtocol { get }
    var footprintService: FootprintServiceProtocol { get }
    var treeService: ScannedTreeServiceProtocol { get }
    
    var userPins: [Pin] { get }
    var isLoading: Bool { get  set }
    var allPins: [Pin] { get }
    var userName: String { get }
    var totalTrees: Int { get }
    var totalSpecies: Int { get }
    var month: String { get }
    var monthlyObjective: Int { get }
    var isShowingShareSheet: Bool { get set }
    var totalCO2: String { get }

    func totalCO2Sequestration() -> Double
    func totalO2() -> Double
    func lapsEarth(totalCO2: Double) -> Double
    func oxygenPerPerson(totalOxygen: Double) -> Int
    func percentageCO2User() -> Int
    func fetchInformation() async
    func calculateMonthlyObjective() async
    func neutralizedAmountThisMonth() -> Double
    func showShareSheet()
    func getTree(for pin: Pin) -> ScannedTree?
}
