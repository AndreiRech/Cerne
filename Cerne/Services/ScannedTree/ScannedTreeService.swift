//
//  ScannedTreeService.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import SwiftData

class ScannedTreeService: ScannedTreeServiceProtocol {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchScannedTrees() throws -> [ScannedTree] {
        let descriptor = FetchDescriptor<ScannedTree>()

        do {
            let pins = try modelContext.fetch(descriptor)
            return pins
        } catch {
            throw GenericError.serviceError
        }
    }
    
    func createScannedTree(species: String, height: Double, dap: Double, totalCO2: Double) throws -> ScannedTree {
        let newTree = ScannedTree(species: species, height: height, dap: dap, totalCO2: totalCO2)
        modelContext.insert(newTree)
        try save()
        
        return newTree
    }
    
    func updateScannedTree(tree: ScannedTree, newSpecies: String?, newHeight: Double?, newDap: Double?) throws {
        tree.species = newSpecies ?? tree.species
        tree.height = newHeight ?? tree.height
        tree.dap = newDap ?? tree.dap
        try save()
    }
    
    private func save() throws{
        try modelContext.save()
    }
}
