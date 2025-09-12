//
//  PinDetailsViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 10/09/25.
//

import Foundation

@Observable
class PinDetailsViewModel: PinDetailsViewModelProtocol {
    func sharePin() {
        
    }
    
    var pin: Pin?
    
    private let pinService: PinService
    
    init(pinService: PinService) {
        self.pinService = pinService
    }
    
    func fetchPin(id: UUID) {
        //MARK: TO DO: Fetch Pin
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
}
