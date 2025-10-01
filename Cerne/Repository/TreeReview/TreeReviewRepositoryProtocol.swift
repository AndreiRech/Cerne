//
//  TreeReviewRepositoryProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation
import UIKit

protocol TreeReviewRepositoryProtocol {
    func createTreeAndPin(image: UIImage, species: String, height: Double, dap: Double, latitude: Double, longitude: Double) async throws -> TreeReviewDTO
    func updateScannedTree(tree: ScannedTree, newSpecies: String, newHeight: Double, newDap: Double) async throws -> ScannedTree
}
