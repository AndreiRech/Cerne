//
//  MockScannedTreeService.swift
//  CerneTests
//
//  Created by Gabriel Kowaleski on 09/09/25.
//

@testable import Cerne
import Foundation
import SwiftData

class MockScannedTreeService: ScannedTreeServiceProtocol {
    var scannedTrees: [ScannedTree] = []
    var shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func fetchScannedTrees() throws -> [ScannedTree] {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        return scannedTrees
    }
    
    func createScannedTree(species: String, height: Double, dap: Double, totalCO2: Double) throws -> ScannedTree {
        if shouldFail {
            throw NSError(domain: "MockScannedTreeService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create ScannedTree"])
        }
        let newTree = ScannedTree(species: species, height: height, dap: dap, totalCO2: totalCO2)
        scannedTrees.append(newTree)
        return newTree
    }
    
    func updateScannedTree(tree: ScannedTree, newSpecies: String?, newHeight: Double?, newDap: Double?) throws {
        if shouldFail {
            throw NSError(domain: "MockScannedTreeService", code: 2, userInfo: [NSLocalizedDescriptionKey: "FFailed to update ScannedTree"])
        }
        
        if let index = scannedTrees.firstIndex(where: { $0.id == tree.id }) {
            let treeToUpdate = scannedTrees[index]
            
            treeToUpdate.species = newSpecies ?? treeToUpdate.species
            treeToUpdate.height = newHeight ?? treeToUpdate.height
            treeToUpdate.dap = newDap ?? treeToUpdate.dap
        }
    }
}
