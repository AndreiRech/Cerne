//
//  ScannedTreeService.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import CloudKit

class ScannedTreeService: ScannedTreeServiceProtocol {
    private let publicDB = CKContainer.default().publicCloudDatabase
    
    init() {}
    
    func fetchScannedTrees() async throws -> [ScannedTree] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "CD_ScannedTree", predicate: predicate)
        
        do {
            let (matchResults, _) = try await publicDB.records(matching: query)
            let records = try matchResults.map { try $0.1.get() }
            
            return records.compactMap { ScannedTree(record: $0) }
        } catch {
            print("Erro detalhado do CloudKit em fetchScannedTree: \(error)")
            print("Erro ao buscar arvores: \(error.localizedDescription)")
            throw GenericError.serviceError
        }
    }
    
    func fetchScannedTree(treeID: CKRecord.ID) async throws -> ScannedTree {
        do {
            let record = try await publicDB.record(for: treeID)
            guard let tree = ScannedTree(record: record) else {
                throw GenericError.serviceError
            }
            return tree
        } catch {
            print("Erro detalhado do CloudKit em fetchScannedTree: \(error)")
            print("Erro ao buscar arvores: \(error.localizedDescription)")
            throw GenericError.serviceError
        }
    }
    
    func createScannedTree(species: String, height: Double, dap: Double, totalCO2: Double) async throws -> ScannedTree {
        let newTree = ScannedTree(species: species, height: height, dap: dap, totalCO2: totalCO2)
        
        let treeRecord = CKRecord(recordType: "CD_ScannedTree")
        treeRecord["CD_id"] = newTree.id.uuidString
        treeRecord["CD_species"] = newTree.species
        treeRecord["CD_height"] = newTree.height
        treeRecord["CD_dap"] = newTree.dap
        treeRecord["CD_totalCO2"] = newTree.totalCO2
        
        do {
            let savedRecord = try await publicDB.save(treeRecord)
            guard let savedTree = ScannedTree(record: savedRecord) else {
                throw GenericError.serviceError
            }
            return savedTree
        } catch {
            throw GenericError.serviceError
        }
    }
    
    func updateScannedTree(tree: ScannedTree) async throws -> ScannedTree {
        guard let recordID = tree.recordID else {
            throw GenericError.serviceError
        }
        
        do {
            let recordToUpdate = try await publicDB.record(for: recordID)
            
            recordToUpdate["CD_species"] = tree.species
            recordToUpdate["CD_height"] = tree.height
            recordToUpdate["CD_dap"] = tree.dap
            recordToUpdate["CD_totalCO2"] = tree.totalCO2
            
            let updatedRecord = try await publicDB.save(recordToUpdate)
            
            guard let updatedTree = ScannedTree(record: updatedRecord) else {
                throw GenericError.serviceError
            }
            return updatedTree
            
        } catch {
            throw GenericError.serviceError
        }
    }
    
    func deleteScannedTree(_ tree: ScannedTree) async throws {
        guard let recordID = tree.recordID else {
            throw GenericError.serviceError
        }
        
        do {
            try await publicDB.deleteRecord(withID: recordID)
        } catch {
            throw GenericError.serviceError
        }
    }
}
