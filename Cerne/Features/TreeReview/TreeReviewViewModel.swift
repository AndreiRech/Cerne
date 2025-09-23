//
//  TreeReviewViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 12/09/25.
//

import SwiftUI
import Combine

@Observable
class TreeReviewViewModel: TreeReviewViewModelProtocol {
    var cameraService: CameraServiceProtocol
    var scannedTreeService: ScannedTreeServiceProtocol
    var treeAPIService: TreeAPIServiceProtocol
    var pinService: PinServiceProtocol
    var treeDataService: TreeDataServiceProtocol
    var userService: UserServiceProtocol
    
    var measuredDiameter: Double
    var treeImage: UIImage?
    var estimatedHeight: Double
    var pinLatitude: Double
    var pinLongitude: Double
    var pinUser: User?
    var tree: ScannedTree?
    
    var updateSpecies: String = ""
    var updateHeight: Double = 0.0
    var updateDap: Double = 0.0
    
    var isEditing: Bool = false
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    init(cameraService: CameraServiceProtocol, scannedTreeService: ScannedTreeServiceProtocol, treeAPIService: TreeAPIServiceProtocol, pinService: PinServiceProtocol, treeDataService: TreeDataServiceProtocol, userService: UserServiceProtocol, measuredDiameter: Double, treeImage: UIImage? = nil, estimatedHeight: Double, pinLatitude: Double, pinLongitude: Double) {
        self.cameraService = cameraService
        self.scannedTreeService = scannedTreeService
        self.treeAPIService = treeAPIService
        self.pinService = pinService
        self.treeDataService = treeDataService
        self.userService = userService
        self.measuredDiameter = measuredDiameter
        self.treeImage = treeImage
        self.estimatedHeight = estimatedHeight
        self.pinLatitude = pinLatitude
        self.pinLongitude = pinLongitude
    }
    
    func createScannedTree() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            guard let treeImage else {
                errorMessage = "Nenhuma imagem disponível para identificar."
                return
            }
            
            let response = try await treeAPIService.identifyTree(image: treeImage)
            let species = response.bestMatch
            
            var density: Double
            
            if let foundTree = treeDataService.findTree(byScientificName: species) {
                density = foundTree.density
            } else {
                density = 1.2
            }
            
            let newTree = try scannedTreeService.createScannedTree(
                species: species,
                height: estimatedHeight,
                dap: Double(measuredDiameter),
                totalCO2: calculateCO2(height: estimatedHeight, dap: Float(measuredDiameter), density: density)
            )
            
            tree = newTree
            await createPin()
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Ocorreu um erro ao criar a árvore: \(error.localizedDescription)"
        }
    }
    
    
    func calculateCO2(height: Double, dap: Float, density: Double) -> Double {
        let biomass = calculateBiomass(height: height, dap: dap, density: density)
        let carbon = 0.47 * biomass
        let result = 3.67 * carbon
        return result
    }
    
    func calculateBiomass(height: Double, dap: Float, density: Double) -> Double {
        let result = 0.0673 * pow(density * Double(pow(dap, 2)) * (height * 1000), 0.976)
        return result
    }
    
    func createPin() async {
        do {
            guard let treeImage,
                  let imageData = treeImage.pngData(),
                  let tree = self.tree else {
                errorMessage = "Não foi possível criar o pin. Faltam dados da árvore ou da imagem."
                return
            }
            
            let user = try await userService.fetchOrCreateCurrentUser()
            
            let _ = try pinService.createPin (
                image: imageData,
                latitude: pinLatitude,
                longitude: pinLongitude,
                user: user,
                tree: tree
            )
            
        } catch {
            errorMessage = "Ocorreu um erro ao criar o pino: \(error.localizedDescription)"
        }
        
    }
    
    func updateScannedTree() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let tree = self.tree else {
            errorMessage = "No tree to update."
            return
        }
        
        let density = treeDataService.findTree(byScientificName: updateSpecies)?.density ?? 1.0
        
        tree.species = updateSpecies
        tree.height = updateHeight
        tree.dap = updateDap
        tree.totalCO2 = calculateCO2(height: updateHeight, dap: Float(updateDap), density: density)
        
        do {
            try scannedTreeService.updateScannedTree(
                tree: tree,
                newSpecies: updateSpecies,
                newHeight: updateHeight,
                newDap: updateDap
            )
            
            tree.totalCO2 = calculateCO2(height: updateHeight, dap: Float(updateDap), density: density)
            
        } catch {
            errorMessage = "An error occurred while updating the tree: \(error.localizedDescription)"
        }
    }
    
    
    func cancel() {
        self.tree = nil
        self.errorMessage = nil
        self.isLoading = false
        self.updateSpecies = ""
        self.updateHeight = 0.0
        self.updateDap = 0.0
    }
    
}
