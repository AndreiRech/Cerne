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
}
