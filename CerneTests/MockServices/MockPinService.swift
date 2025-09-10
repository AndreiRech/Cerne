//
//  MockPinService.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 09/09/25.
//

@testable import Cerne
import Foundation
import SwiftData

class MockPinService: PinServiceProtocol {
    var pins: [Pin] = []
    var shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func createPin(image: Data?, latitude: Double, longitude: Double, user: User, tree: ScannedTree) throws {
        if shouldFail {
            throw NSError(domain: "MockPinService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create Pin"])
        }
        
        let newPin = Pin(image: image, latitude: latitude, longitude: longitude, date: Date(), user: user, tree: tree)
        pins.append(newPin)
    }
    
    func addReport(to pin: Pin) throws {
        if shouldFail {
            throw NSError(domain: "MockPinService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to add report"])
        }
        
        if let index = pins.firstIndex(where: { $0.id == pin.id }) {
            pins[index].reports += 1
        }
    }
    
    func deletePin(pin: Pin) throws {
        if shouldFail {
            throw NSError(domain: "MockPinService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to delete Pin"])
        }
        
        pins.removeAll { $0.id == pin.id }
    }
}
