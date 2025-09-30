//
//  ProfileViewModelProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 26/09/25.
//

import Foundation

protocol ProfileViewModelProtocol {
    var pinService: PinServiceProtocol { get }
    var userService: UserServiceProtocol { get }
    var footprintService: FootprintServiceProtocol { get }
    var userPins: [Pin] { get }
    var footprint: String? { get }
    var isLoading: Bool { get  set }
    var annualData: [MonthlyData] { get set }
    var monthlyObjective: Int { get set }
    
    func fetchUserPins() async
    func fetchFootprint() async
    func deleteAccount() async
    func totalCO2User() -> String
    func CO2AnualPercent() -> Int
    func calculateAnnualProgress()
}
