//
//  MockScannedTreeService.swift
//  CerneTests
//
//  Created by Gabriel Kowaleski on 09/09/25.
//

@testable import Cerne
import Foundation
import CloudKit

class MockScannedTreeService: ScannedTreeServiceProtocol {
    var scannedTrees: [ScannedTree] = []
    var shouldFail: Bool
    
    init(shouldFail: Bool = false, initialTrees: [ScannedTree] = []) {
        self.shouldFail = shouldFail
        self.scannedTrees = initialTrees
    }
    
    func fetchScannedTrees() async throws -> [ScannedTree] {
        if shouldFail {
            throw GenericError.serviceError
        }
        return scannedTrees
    }
    
    func fetchScannedTree(treeID: CKRecord.ID) async throws -> ScannedTree {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        if let tree = scannedTrees.first(where: { $0.recordID == treeID }) {
            return tree
        }
        
        throw CKError(.unknownItem)
    }
    
    func createScannedTree(species: String, height: Double, dap: Double, totalCO2: Double) async throws -> ScannedTree {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        var newTree = ScannedTree(species: species, height: height, dap: dap, totalCO2: totalCO2)
        let newRecordID = CKRecord.ID(recordName: newTree.id.uuidString)
        newTree.recordID = newRecordID
        
        scannedTrees.append(newTree)
        return newTree
    }
    
    func updateScannedTree(tree: ScannedTree) async throws -> ScannedTree {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        guard let recordID = tree.recordID,
              let index = scannedTrees.firstIndex(where: { $0.recordID == recordID }) else {
            throw CKError(.unknownItem)
        }
        
        scannedTrees[index] = tree
        return tree
    }
    
    func deleteScannedTree(_ tree: ScannedTree) async throws {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        guard let recordID = tree.recordID,
              let index = scannedTrees.firstIndex(where: { $0.recordID == recordID }) else {
            throw CKError(.unknownItem)
        }
        
        scannedTrees.remove(at: index)
    }
}
