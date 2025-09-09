//
//  PinService.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import SwiftData

class PinService: PinServiceProtocol {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func createPin(image: Data?, latitude: Double, longitude: Double, user: User, tree: ScannedTree) throws {
        let newPin = Pin(image: image, latitude: latitude, longitude: longitude, date: Date(), user: user, tree: tree)
        modelContext.insert(newPin)
        try save()
    }
    
    func addReport(to pin: Pin) throws {
        pin.reports += 1
        try save()
    }
    
    func deletePin(pin: Pin) throws {
        modelContext.delete(pin)
        try save()
    }
    
    private func save() throws {
        try modelContext.save()
    }
}
