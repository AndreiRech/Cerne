//
//  TodayViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import Foundation

@Observable
@MainActor
class TodayViewModel: TodayViewModelProtocol {
    var pinService: PinServiceProtocol
    var userService: UserServiceProtocol
    var footprintService: FootprintServiceProtocol
    var userPins: [Pin] = []
    var isLoading: Bool = false
    var allPins: [Pin] = []
    var userName: String = ""
    
    var month: String = Date().formatted(.dateTime.month(.wide).locale(Locale(identifier: "pt_BR"))).capitalized
    var monthlyObjective: Int = 100
    
    var totalTrees: Int {
        allPins.count
    }
    
    var totalSpecies: Int {
        Set(allPins.compactMap { $0.tree?.species }).count
    }
    
    init(pinService: PinServiceProtocol, userService: UserServiceProtocol, footprintService: FootprintServiceProtocol) {
        self.pinService = pinService
        self.userService = userService
        self.footprintService = footprintService
    }
    
    func fetchUserPins() async {
        self.isLoading = true
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            self.userPins = currentUser.pins ?? []
            
        } catch {
            print("Erro ao buscar os pins do usuário: \(error.localizedDescription)")
            self.userPins = []
        }
        self.isLoading = false
    }
    
    func fetchAllPins() async {
        do {
            self.allPins = try pinService.fetchPins()
        } catch {
            print("Falha ao carregar os pins da comunidade: \(error.localizedDescription)")
            self.allPins = []
        }
    }
    
    func totalCO2Sequestration() -> Double {
        let totalInKg = allPins.compactMap { $0.tree?.totalCO2 }.reduce(0, +)
        return totalInKg / 1000.0
    }
    
    func totalO2() -> Double {
        let totalCO2InKg = allPins.compactMap { $0.tree?.totalCO2 }.reduce(0, +)
        return (totalCO2InKg / 44.0) * 32.0 / 1000.0
    }
    
    func lapsEarth(totalCO2: Double) -> Double {
        let laps = totalCO2 * 0.108
        return laps
    }
    
    func oxygenPerPerson(totalOxygen: Double) -> Int {
        let oxygenPerPerson = totalOxygen * 3.5
        return Int(oxygenPerPerson.rounded())
        
    }
    
    func totalCO2User() -> Double {
        let totalInKg = userPins.compactMap(\.tree?.totalCO2).reduce(0, +)
        return totalInKg
    }
    
    func percentageCO2User() -> Int {
        let totalCO2User = neutralizedAmountThisMonth()
        let objective = Double(monthlyObjective)
        
        if objective == 0 {
            return 0
        }
        
        var total = Int((totalCO2User / objective) * 100.0)
        
        if total > 100 {
            total = 100
        }

        return total
    }
    
    func fetchCurrentUser() async {
        do {
            let user = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            self.userName = user.name
        } catch {
            print("Erro ao buscar o usuário: \(error.localizedDescription)")
            self.userName = "Usuário"
        }
    }
    
    //TO DO: Colocar como zero quando adicionar os empty States
    func calculateMonthlyObjective() async {
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            if let userFootprint = try footprintService.fetchFootprint(for: currentUser) {
                self.monthlyObjective = Int(userFootprint.total / 12)
            } else {
                self.monthlyObjective = 100
           }
        } catch {
            print("Erro ao calcular o objetivo do mês: \(error.localizedDescription)")
            self.monthlyObjective = 100
        }
    }
    
    func neutralizedAmountThisMonth() -> Double {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())

        let pinsThisMonth = userPins.filter { pin in
            let pinMonth = calendar.component(.month, from: pin.date)
            let pinYear = calendar.component(.year, from: pin.date)
            return pinMonth == currentMonth && pinYear == currentYear
        }

        let totalInKg = pinsThisMonth.compactMap(\.tree?.totalCO2).reduce(0, +)
        return totalInKg
    }
}

