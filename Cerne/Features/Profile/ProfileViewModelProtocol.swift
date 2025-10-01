//
//  ProfileViewModelProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 26/09/25.
//

import Foundation

protocol ProfileViewModelProtocol {
    var userName: String { get }
    var userPins: [Pin] { get }
    var footprint: String? { get }
    var isLoading: Bool { get  set }
    var totalCO2: String { get }
    var isShowingDeleteAlert: Bool { get set }
    var annualData: [MonthlyData] { get set }
    var monthlyObjective: Int { get set }
    
    func fetchData() async
    func deleteAccount() async
    func CO2AnualPercent() -> Int
    func calculateAnnualProgress()
}
