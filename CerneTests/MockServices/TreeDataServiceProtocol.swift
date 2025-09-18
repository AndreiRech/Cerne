//
// MockTreeDataService.swift
//  Cerne
//
//  Created by Maria Santellano on 18/09/25.
//

@testable import Cerne
import Foundation

class MockTreeDataService: TreeDataServiceProtocol {
   
    var mockTreeDetails: [TreeDetails]
    
    init(mockDetails: [TreeDetails] = [
        TreeDetails(
            commonName: "Araucária",
            scientificName: "Araucaria angustifolia",
            density: 0.5,
            description: "Árvore símbolo do sul do Brasil."
        )
    ]) {
        self.mockTreeDetails = mockDetails
    }
    
    
    func findTree(byScientificName scientificName: String) -> TreeDetails? {
        let searchName = scientificName.lowercased().trimmingCharacters(in: .whitespaces)
        
        let foundTree = mockTreeDetails.first { tree in
            return tree.scientificName.lowercased().trimmingCharacters(in: .whitespaces) == searchName
        }
        
        return foundTree
    }
}
