//
//  ScannedTreeServiceProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import SwiftData

protocol ScannedTreeServiceProtocol {
    func createScannedTree(species: String, height: Double, dap: Double, totalCO2: Double) throws -> ScannedTree

    func updateScannedTree(tree: ScannedTree, newSpecies: String?, newHeight: Double?, newDap: Double?) throws
}
