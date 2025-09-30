//
//  ProfileViewModel.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 26/09/25.
//

import Foundation

@Observable
class ProfileViewModel: ProfileViewModelProtocol {
    var pinService: PinServiceProtocol
    var userService: UserServiceProtocol
    var footprintService: FootprintServiceProtocol
    var userDefaultService: UserDefaultServiceProtocol
    var userPins: [Pin] = []
    var footprint: String?
    var isLoading: Bool = true
    var annualData: [MonthlyData] = []
    var monthlyObjective: Int = 0
    
    private var annualObjective: Double = 0.0
    
    init(pinService: PinServiceProtocol, userService: UserServiceProtocol, footprintService: FootprintServiceProtocol, userDefaultService: UserDefaultServiceProtocol) {
        self.pinService = pinService
        self.userService = userService
        self.footprintService = footprintService
        self.userDefaultService = userDefaultService
    }
    
    func fetchUserPins() async {
        self.isLoading = true
        
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            self.userPins = currentUser.pins ?? []
            await fetchFootprint()
            calculateAnnualProgress()
        } catch {
            print("Erro ao buscar os pins do usuário: \(error.localizedDescription)")
            self.userPins = []
        }
    }
    
    func fetchFootprint() async {
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            
            if let userFootprint = try footprintService.fetchFootprint(for: currentUser) {
                let totalInKg = userFootprint.total
                footprint = String(format: "%.0f Kg", totalInKg)
                
                self.annualObjective = totalInKg
                self.monthlyObjective = Int(totalInKg / 12)
            }
        } catch {
            print("Erro ao carregar o footprint: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
    
    func deleteAccount() async {
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            try userService.deleteUser(currentUser)
            userDefaultService.setOnboarding(value: false)
            userDefaultService.setFirstTime(value: false)
        } catch {
            print("Erro ao deletar o usuário: \(error.localizedDescription)")
        }
    }
        
    func totalCO2User() -> String {
        let totalInKg = userPins.compactMap(\.tree?.totalCO2).reduce(0, +)
        return String(format: "%.0f", totalInKg)
    }
    
    func CO2AnualPercent() -> Int {
        if annualObjective == 0 {
            return 0
        }
            
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())

        let currentYearPins = userPins.filter {
            calendar.component(.year, from: $0.date) == currentYear
        }
        let totalNeutralized = currentYearPins.compactMap(\.tree?.totalCO2).reduce(0, +)

        let percentage = (totalNeutralized / annualObjective) * 100.0
            
        let finalPercentage = Int(round(max(0, min(percentage, 100.0))))
            
        return finalPercentage
    }
    
    func calculateAnnualProgress() {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        var monthlyTotals = Array(repeating: 0.0, count: 12)

        let currentYearPins = userPins.filter {
            calendar.component(.year, from: $0.date) == currentYear
        }

        for pin in currentYearPins {
            let month = calendar.component(.month, from: pin.date) - 1
            if month >= 0 && month < 12 {
                monthlyTotals[month] += pin.tree?.totalCO2 ?? 0.0
            }
        }

        let monthSymbols = calendar.shortMonthSymbols.map { String($0.prefix(1)) }
        let objective = Double(monthlyObjective)
            
        self.annualData = monthlyTotals.enumerated().map { (index, total) -> MonthlyData in
            var normalizedHeight = 0.0
            
            if objective > 0 {
                let percentage = total / objective
                normalizedHeight = min(percentage, 1.0)
            }
                    
            return MonthlyData(month: monthSymbols[index], normalizedHeight: normalizedHeight)
        }
    }
}
