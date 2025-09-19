//
//  TreeDataService.swift
//  Cerne
//
//  Created by Maria Santellano on 17/09/25.
//


// TreeDataService.swift

import Foundation

class TreeDataService: TreeDataServiceProtocol {
    private var allTrees: [TreeDetails] = []
    
    init() {
        do {
            self.allTrees = try self.loadTreesFromJSON()
        } catch {
            self.allTrees = []
        }
    }
    
    func findTree(byScientificName scientificName: String) -> TreeDetails? {
        let searchName = scientificName.lowercased().trimmingCharacters(in: .whitespaces)
        
        let foundTree = allTrees.first { tree in
            return tree.scientificName.lowercased().trimmingCharacters(in: .whitespaces) == searchName
        }
        
        return foundTree
    }
    
    private func loadTreesFromJSON() throws -> [TreeDetails] {
        guard let url = Bundle.main.url(forResource: "Tree", withExtension: "json") else {
            throw JsonError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let trees = try decoder.decode([TreeDetails].self, from: data)
            print("✅ Sucesso! \(trees.count) árvores carregadas do JSON.")
            return trees
            
        } catch {
            throw JsonError.invalidJsonFormat
        }
    }
}
