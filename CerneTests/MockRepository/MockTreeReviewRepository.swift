//
//  MockTreeReviewRepository.swift
//  Cerne
//
//  Created by Andrei Rech on 01/10/25.
//

import Foundation
import UIKit
@testable import Cerne

class MockTreeReviewRepository: TreeReviewRepositoryProtocol {
    var shouldFail: Bool = false
    var mockCreatedTree: ScannedTree?
    var mockCreatedPin: Pin?
    var mockUpdatedTree: ScannedTree?
    
    func createTreeAndPin(image: UIImage, species: String, height: Double, dap: Double, latitude: Double, longitude: Double) async throws -> TreeReviewDTO {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        guard let tree = mockCreatedTree, let pin = mockCreatedPin else {
            fatalError("MockTreeReviewRepository não configurado para criação. Defina mockCreatedTree e mockCreatedPin.")
        }
        
        return TreeReviewDTO(createdTree: tree, createdPin: pin)
    }
    
    func updateScannedTree(tree: ScannedTree, newSpecies: String, newHeight: Double, newDap: Double) async throws -> ScannedTree {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        guard var updatedTree = mockUpdatedTree else {
            fatalError("MockTreeReviewRepository não configurado para atualização. Defina mockUpdatedTree.")
        }

        updatedTree.species = newSpecies
        updatedTree.height = newHeight
        updatedTree.dap = newDap
        
        return updatedTree
    }
}
