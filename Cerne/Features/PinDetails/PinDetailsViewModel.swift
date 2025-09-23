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
    let userDefaultService: UserDefaultServiceProtocol
    var allDetails: [TreeDetails] = []
    var details: TreeDetails?
    var isPinFromUser: Bool = false
    var errorMessage: String?
    var reportEnabled: Bool = true
    
    init(pin: Pin, pinService: PinServiceProtocol, userService: UserServiceProtocol, userDefaultService: UserDefaultServiceProtocol) {
        self.pin = pin
        self.pinService = pinService
        self.userService = userService
        self.userDefaultService = userDefaultService
        setup()
    }
    
    private func setup() {
        do {
            allDetails = try pinService.getDetails(fileName: "Tree")
            details = allDetails.first(where: { $0.scientificName.lowercased().contains(pin.tree?.species.lowercased() ?? "") })
        } catch {
            errorMessage = "Failed to get details - Tree does not exist in JSON"
        }
    }
    
    func deletePin(pin: Pin) {
        do {
            try pinService.deletePin(pin: pin)
        } catch {
            errorMessage = "Failed to delete pin"
        }
    }
    
    func reportPin(to pin: Pin) {
        reportEnabled = isAbleToReport(pin: pin) ? true : false
        
        do {
            try pinService.addReport(to: pin)
            userDefaultService.setPinReported(pin: pin)
        } catch {
            errorMessage = "Failed to report pin"
        }
    }
    
    func isPinFromUser() async {
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser()
            
            isPinFromUser = currentUser == pin.user ? true : false
        } catch {
            errorMessage = "Failed to get user for pin"
        }
    }
    
    private func isAbleToReport(pin: Pin) -> Bool {
        return userDefaultService.isPinReported(pin: pin) ? false : true
    }
}
