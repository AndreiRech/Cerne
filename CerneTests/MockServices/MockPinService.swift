//
//  MockPinService.swift
//  CerneTests
//
//  Created by Gabriel Kowaleski on 09/09/25.
//

@testable import Cerne
import Foundation
import CloudKit
import UIKit

class MockPinService: PinServiceProtocol {
    var pins: [Pin]
    var details: [TreeDetails]
    var shouldFail: Bool
    
    init(shouldFail: Bool = false, initialPins: [Pin] = [], initialDetails: [TreeDetails] = []) {
        self.shouldFail = shouldFail
        self.pins = initialPins
        self.details = initialDetails
        
        if self.details.isEmpty {
            self.details.append(TreeDetails(commonName: "Ipê-amarelo", scientificName: "Handroanthus albus", density: 1.0, description: "Árvore ornamental"))
        }
    }
    
    func fetchPins() async throws -> [Pin] {
        if shouldFail {
            throw GenericError.serviceError
        }
        return pins
    }
    
    func createPin(image: UIImage, latitude: Double, longitude: Double, user: User, tree: ScannedTree) async throws -> Pin {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        guard let userRecordID = user.recordID, let treeRecordID = tree.recordID else {
            throw GenericError.serviceError
        }
        
        var newPin = Pin(image: image, latitude: latitude, longitude: longitude, date: Date(), userRecordID: userRecordID, treeRecordID: treeRecordID)
        newPin.recordID = CKRecord.ID(recordName: newPin.id.uuidString)
        
        pins.append(newPin)
        return newPin
    }
    
    func addReport(to pin: Pin) async throws -> Pin? {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        guard let recordID = pin.recordID,
              let index = pins.firstIndex(where: { $0.recordID == recordID }) else {
            throw CKError(.unknownItem)
        }
        
        pins[index].reports += 1
        
        if pins[index].reports >= 5 {
            pins.remove(at: index)
            return nil
        }
        
        return pins[index]
    }
    
    func deletePin(_ pin: Pin) async throws {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        guard let recordID = pin.recordID,
              let index = pins.firstIndex(where: { $0.recordID == recordID }) else {
            throw CKError(.unknownItem)
        }
        
        pins.remove(at: index)
    }
    
    func getDetails(fileName: String) throws -> [TreeDetails] {
        if shouldFail {
            throw JsonError.fileNotFound
        }
        return details
    }
    
    func getDetails(for tree: ScannedTree) throws -> TreeDetails {
        if shouldFail {
            throw GenericError.detailsNotFound
        }
        
        let treeName = tree.species.lowercased()
        
        if let detail = details.first(where: { $0.scientificName.lowercased().contains(treeName) }) {
            return detail
        }
        
        throw GenericError.detailsNotFound
    }
}
