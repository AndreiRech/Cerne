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
    var userPins: [Pin] = []
    var isLoading: Bool = false
    var allPins: [Pin] = []
    
    var month: String = Date().formatted(.dateTime.month(.wide).locale(Locale(identifier: "pt_BR")))
    var monthlyObjective: Int = 1
    
    var totalTrees: Int {
        allPins.count
    }
    
    var totalSpecies: Int {
        Set(allPins.compactMap { $0.tree?.species }).count
    }
    
    init(pinService: PinServiceProtocol, userService: UserServiceProtocol) {
        self.pinService = pinService
        self.userService = userService
    }
    
    func fetchUserPins() async {
        self.isLoading = true
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser()
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

    
}


