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
    
    
    
}


