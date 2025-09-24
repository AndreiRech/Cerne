//
//  TodayViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import Foundation

@Observable
class TodayViewModel: TodayViewModelProtocol {
    var pinService: PinServiceProtocol
    var userService: UserServiceProtocol
    var userPins: [Pin] = []
    
    init(pinService: PinServiceProtocol, userService: UserServiceProtocol) {
        self.pinService = pinService
        self.userService = userService
    }
    
    func fetchUserPins() async {
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser()
            self.userPins = try pinService.fetchPins(by: currentUser)
            
        } catch {
            print("Erro ao buscar os pins do usuário: \(error.localizedDescription)")
            self.userPins = []
        }
    }
}


