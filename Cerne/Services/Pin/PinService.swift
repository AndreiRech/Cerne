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
    var details: [TreeDetails]
    
    @MainActor
    init(details: [TreeDetails] = []) {
        self.modelContext = Persistence.shared.modelContext
        self.details = []
    }
    
    func fetchPins() throws -> [Pin] {
        let descriptor = FetchDescriptor<Pin>()

        do {
            let pins = try modelContext.fetch(descriptor)
            print(pins)
            return pins
        } catch {
            throw GenericError.serviceError
        }
    }
    
    func createPin(image: Data, latitude: Double, longitude: Double, user: User, tree: ScannedTree) throws {
        let newPin = Pin(image: image, latitude: latitude, longitude: longitude, date: Date(), user: user, tree: tree)
        modelContext.insert(newPin)
        try save()
    }
    
    func addReport(to pin: Pin) throws {
        pin.reports += 1
        if pin.reports == 5 {
            modelContext.delete(pin)
        }
        try save()
    }
    
    func deletePin(pin: Pin) throws {
        modelContext.delete(pin)
        try save()
    }
    
    func getDetails(fileName: String) throws -> [TreeDetails] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw JsonError.fileNotFound
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw JsonError.errorLoadingData
        }
        
        let decoder = JSONDecoder()
        
        do {
            let details = try decoder.decode([TreeDetails].self, from: data)
            return details
        } catch {
            throw JsonError.invalidJsonFormat
        }
    }
    
    func getDetails(for tree: ScannedTree) throws -> TreeDetails {
        let treeName = tree.species.lowercased()
        
        for detail in details {
            if detail.scientificName.contains(treeName) {
                return detail
            }
        }
        
        throw GenericError.detailsNotFound
    }
    
    private func save() throws {
        try modelContext.save()
    }
}
