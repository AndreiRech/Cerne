//
//  PinDetailsViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 10/09/25.
//

import Foundation

@Observable
class PinDetailsViewModel: PinDetailsViewModelProtocol {
    var pin: Pin
    let pinService: PinServiceProtocol
    let userService: UserServiceProtocol
    var allDetails: [TreeDetails] = []
    var details: TreeDetails?
    var isPinFromUser: Bool = false
    
    init(pin: Pin, pinService: PinServiceProtocol, userService: UserServiceProtocol) {
        self.pin = pin
        self.pinService = pinService
        self.userService = userService
        setup()
    }
    
    private func setup() {
        do {
            allDetails = try pinService.getDetails(fileName: "Tree")
            details = allDetails.first(where: { $0.scientificName.lowercased().contains(pin.tree?.species.lowercased() ?? "") })
        } catch {
            print("Failed to get details - SETUP")
        }
    }
    
    func deletePin(pin: Pin) {
        do {
            try pinService.deletePin(pin: pin)
        } catch {
            print("Failed to delete")
        }
    }
    
    func reportPin(to pin: Pin) {
        do {
            try pinService.addReport(to: pin)
        } catch {
            print("Failed to report pin")
        }
    }
    
    func isPinFromUser() async {
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser()
            
            isPinFromUser = currentUser == pin.user ? true : false
        } catch {
            print("Failed to get details - USER")
        }
    }
    
    func message() -> String {
        let co2 = pin.tree?.totalCO2 ?? 0.0
        
        if co2 < 300 {
            let carEmissionsPerKm = 0.17
            let equivalentKm = co2 / carEmissionsPerKm
            let formattedKm = String(format: "%.1f", equivalentKm)
            
            return "A captura dessa árvore equivale a emissão de um carro, movido a gasolina, rodando \(formattedKm) km"
        } else if co2 < 600 {
            let truckEmissionsPerKm = 1.0
            let equivalentKm = co2 / truckEmissionsPerKm
            let formattedKm = String(format: "%.1f", equivalentKm)
            
            return "A captura dessa árvore equivale à emissão de um caminhão a diesel rodando cerca de \(formattedKm) km."
        } else {
            let airplaneEmissionsPerHour = 90.0
            let equivalentHours = co2 / airplaneEmissionsPerHour
            let formattedHours = String(format: "%.1f", equivalentHours)
            
            return "A captura dessa árvore equivale à emissão de um voo comercial de aproximadamente \(formattedHours) horas."
        }
    }
}
