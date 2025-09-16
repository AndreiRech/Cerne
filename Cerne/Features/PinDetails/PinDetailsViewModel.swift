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
    var allDetails: [TreeDetails] = []
    var details: TreeDetails?
    
    init(pin: Pin, pinService: PinServiceProtocol) {
        self.pin = pin
        self.pinService = pinService
        setup()
    }
    
    private func setup() {
        do {
            allDetails = try pinService.getDetails(fileName: "Tree")
            details = allDetails.first(where: { $0.scientificName.lowercased().contains(pin.tree.species.lowercased()) })
        } catch {
            print("Failed to get details")
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
    
    func isPinFromUser() -> Bool {
        return false
    }
}
