//
//  ProfileViewModel.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 26/09/25.
//

import Foundation

class ProfileViewModel: ProfileViewModelProtocol {
    var pinService: PinServiceProtocol
    var userService: UserServiceProtocol
    var footprintService: FootprintServiceProtocol
    var userPins: [Pin] = []
    var footprint: String?
    var isLoading: Bool = false
    
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
    
    func fetchFootprint() async {
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            let userFootprint = try footprintService.fetchFootprint(for: currentUser)
            
            if let userFootprint = try footprintService.fetchFootprint(for: currentUser) {
                let totalInKg = userFootprint.total
                footprint = String(format: "%.0f Kg", totalInKg)
            }
        } catch {
            print("Erro ao carregar o footprint: \(error.localizedDescription)")
        }
    }
        
    func totalCO2User() -> String {
        let totalInKg = userPins.compactMap(\.tree?.totalCO2).reduce(0, +)
        return String(totalInKg)
    }
}
