//
//  ScannedTreeServiceProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import CloudKit

protocol ScannedTreeServiceProtocol {
    func fetchScannedTrees() async throws -> [ScannedTree]
    func fetchScannedTree(treeID: CKRecord.ID) async throws -> ScannedTree
    func createScannedTree(species: String, height: Double, dap: Double, totalCO2: Double) async throws -> ScannedTree
    func updateScannedTree(tree: ScannedTree) async throws -> ScannedTree
    func deleteScannedTree(_ tree: ScannedTree) async throws
}
