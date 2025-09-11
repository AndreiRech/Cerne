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
    var details: [TreeDetails]
    var pins: [Pin] = []
    var shouldFail: Bool
    
    init(shouldFail: Bool = false, details: [TreeDetails] = [TreeDetails(commonName: "normal", scientificName: "cientifico", density: 1.0, description: "texto")]) {
        self.shouldFail = shouldFail
        self.details = details
    }
    
    func fetchPins() throws -> [Pin] {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        return pins
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
    
    
    func getDetails(fileName: String) throws -> [TreeDetails] {
        if shouldFail {
            throw JsonError.fileNotFound
        }
        
        return [TreeDetails(commonName: "normal", scientificName: "cientifico", density: 1.0, description: "texto")]
    }
    
    func getDetails(for tree: ScannedTree) throws -> TreeDetails {
        for detail in details {
            if detail.scientificName.contains(tree.species.lowercased()) {
                return detail
            }
        }
        
        throw GenericError.detailsNotFound
    }
}
