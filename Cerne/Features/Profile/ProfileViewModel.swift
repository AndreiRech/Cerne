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
    var treeService: ScannedTreeServiceProtocol
    
    var userPins: [Pin] = []
    var footprint: String?
    var isLoading: Bool = true
    var totalCO2: String = "0"
    
    init(pinService: PinServiceProtocol, userService: UserServiceProtocol, footprintService: FootprintServiceProtocol, userDefaultService: UserDefaultServiceProtocol, treeService: ScannedTreeServiceProtocol) {
        self.pinService = pinService
        self.userService = userService
        self.footprintService = footprintService
        self.userDefaultService = userDefaultService
        self.treeService = treeService
    }
    
    func fetchUserPins() async {
        self.isLoading = true
        
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            let pins = try await pinService.fetchPins()
            let tree = try await treeService.fetchScannedTrees()
            
            var total: Double = 0.0
            for pin in pins {
                if pin.userRecordID == currentUser.recordID {
                    self.userPins.append(pin)
                }
                
                for scannedTree in tree {
                    if pin.treeRecordID == scannedTree.recordID {
                        total += scannedTree.totalCO2
                    }
                }
            }
            totalCO2 = String(format: "%.0f", total)
            
            await fetchFootprint()
        } catch {
            print("Erro ao buscar os pins do usuário: \(error.localizedDescription)")
            self.userPins = []
        }
    }
    
    func fetchFootprint() async {
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            
            if let userFootprint = try await footprintService.fetchFootprint(for: currentUser) {
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
            try await userService.deleteUser(currentUser)
            userDefaultService.setOnboarding(value: false)
            userDefaultService.setFirstTime(value: false)
        } catch {
            print("Erro ao deletar o usuário: \(error.localizedDescription)")
        }
    }
}
