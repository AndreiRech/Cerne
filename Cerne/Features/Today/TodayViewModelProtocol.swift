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
    var userPins: [Pin] { get }
    var isLoading: Bool { get  set }
    var allPins: [Pin] { get }
    var totalTrees: Int { get }
    var totalSpecies: Int { get }
    var month: String { get }
    var monthlyObjective: Int { get }
//    var totalCO2Sequestration: Double { get }
//    var totalO2: Double { get }

    

    func fetchUserPins() async
    func fetchAllPins() async
    
    func totalCO2Sequestration() -> Double
    func totalO2() -> Double
    func lapsEarth(totalCO2: Double) -> Double
    func oxygenPerPerson(totalOxygen: Double) -> Int

}
