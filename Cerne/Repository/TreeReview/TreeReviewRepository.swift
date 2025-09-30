//
//  TreeReviewRepository.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation
import UIKit

class TreeReviewRepository: TreeReviewRepositoryProtocol {
    private let scannedTreeService: ScannedTreeServiceProtocol
    private let treeAPIService: TreeAPIServiceProtocol
    private let pinService: PinServiceProtocol
    private let treeDataService: TreeDataServiceProtocol
    private let userService: UserServiceProtocol
    private let userDefaultService: UserDefaultServiceProtocol
    private let cacheService: CacheServiceProtocol

    init(
        scannedTreeService: ScannedTreeServiceProtocol,
        treeAPIService: TreeAPIServiceProtocol,
        pinService: PinServiceProtocol,
        treeDataService: TreeDataServiceProtocol,
        userService: UserServiceProtocol,
        userDefaultService: UserDefaultServiceProtocol,
        cacheService: CacheServiceProtocol = CacheService.shared
    ) {
        self.scannedTreeService = scannedTreeService
        self.treeAPIService = treeAPIService
        self.pinService = pinService
        self.treeDataService = treeDataService
        self.userService = userService
        self.userDefaultService = userDefaultService
        self.cacheService = cacheService
    }
    
    func createTreeAndPin(image: UIImage, height: Double, dap: Double, latitude: Double, longitude: Double) async throws -> TreeReviewDTO {
        let response = try await treeAPIService.identifyTree(image: image)
        let species = response.bestMatch
        
        let density = treeDataService.findTree(byScientificName: species)?.density ?? 1.2
        
        let newTree = try await scannedTreeService.createScannedTree(
            species: species,
            height: height,
            dap: dap,
            totalCO2: calculateCO2(height: height, dap: Float(dap), density: density)
        )
        
        let cachedUser: User? = cacheService.get(forKey: .currentUser)
        
        async let userTask: User = {
            if let cachedUser {
                return cachedUser
            }
            return try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
        }()
        
        let finalUser = try await userTask

        let newPin = try await pinService.createPin(
            image: image,
            latitude: latitude,
            longitude: longitude,
            user: finalUser,
            tree: newTree
        )

        updateCacheWithNewData(pin: newPin, tree: newTree)
        
        userDefaultService.setFirstTime(value: true)
        
        return TreeReviewDTO(createdTree: newTree, createdPin: newPin)
    }
    
    func updateScannedTree(tree: ScannedTree, newSpecies: String, newHeight: Double, newDap: Double) async throws -> ScannedTree {
        var mutableTree = tree
        let density = treeDataService.findTree(byScientificName: newSpecies)?.density ?? 1.0
        
        mutableTree.species = newSpecies
        mutableTree.height = newHeight
        mutableTree.dap = newDap
        mutableTree.totalCO2 = calculateCO2(height: newHeight, dap: Float(newDap), density: density)
        
        let updatedTree = try await scannedTreeService.updateScannedTree(tree: mutableTree)
        
        if var cachedTrees: [ScannedTree] = cacheService.get(forKey: .allScannedTrees),
           let index = cachedTrees.firstIndex(where: { $0.recordID == updatedTree.recordID }) {
            cachedTrees[index] = updatedTree
            cacheService.set(cachedTrees, forKey: .allScannedTrees)
        }
        
        return updatedTree
    }
    
    private func updateCacheWithNewData(pin: Pin, tree: ScannedTree) {
        if var allPins: [Pin] = cacheService.get(forKey: .allPins) {
            allPins.append(pin)
            cacheService.set(allPins, forKey: .allPins)
        }
        
        if var allTrees: [ScannedTree] = cacheService.get(forKey: .allScannedTrees) {
            allTrees.append(tree)
            cacheService.set(allTrees, forKey: .allScannedTrees)
        }
    }

    private func calculateCO2(height: Double, dap: Float, density: Double) -> Double {
        let biomass = calculateBiomass(height: height, dap: dap, density: density)
        return 3.67 * (0.47 * biomass)
    }
    
    private func calculateBiomass(height: Double, dap: Float, density: Double) -> Double {
        return 0.0673 * pow(density * Double(pow(dap, 2)) * (height * 1000), 0.976)
    }
}
