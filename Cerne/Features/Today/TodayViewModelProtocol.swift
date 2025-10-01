//
//  TodayViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import Foundation

protocol TodayViewModelProtocol {
    var userPins: [Pin]  { get }
    var allPins: [Pin]  { get }
    var userName: String  { get }
    var userFootprint: Footprint? { get }
    var totalCO2: String { get }
    var isShowingShareSheet: Bool { get set }
    var isLoading: Bool { get set }
    var month: String { get }
    var monthlyObjective: Int { get }
    var totalTrees: Int { get }
    var totalSpecies: Int { get }

    func totalCO2Sequestration() -> Double
    func totalO2() -> Double
    func lapsEarth(totalCO2: Double) -> Double
    func oxygenPerPerson(totalOxygen: Double) -> Int
    func percentageCO2User() -> Int
    func fetchData() async
    func neutralizedAmountThisMonth() -> Double
    func showShareSheet()
    func getTree(for pin: Pin) -> ScannedTree?
}
