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
    
    var measuredDiameter: Float
    var treeImage: UIImage?
    var estimatedHeight: Double
    var pinLatitude: Double
    var pinLongitude: Double
    var pinUser: User?
    var tree: ScannedTree?
    
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    init(cameraService: CameraServiceProtocol, scannedTreeService: ScannedTreeServiceProtocol, treeAPIService: TreeAPIServiceProtocol, pinService: PinServiceProtocol, measuredDiameter: Float, treeImage: UIImage? = nil, estimatedHeight: Double, pinLatitude: Double, pinLongitude: Double /*pinUser: User*/) {
        self.cameraService = cameraService
        self.scannedTreeService = scannedTreeService
        self.treeAPIService = treeAPIService
        self.pinService = pinService
        self.measuredDiameter = measuredDiameter
        self.treeImage = treeImage
        self.estimatedHeight = estimatedHeight
        self.pinLatitude = pinLatitude
        self.pinLongitude = pinLongitude
//        self.pinUser = pinUser
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
            
            
            let newTree = try scannedTreeService.createScannedTree(
                species: species,
                height: estimatedHeight,
                dap: Double(measuredDiameter),
                totalCO2: calculateCO2(height: estimatedHeight, dap: measuredDiameter, density: 1.5)
            )
            
            tree = newTree
            
            print("🌱 Árvore criada com sucesso: \(newTree)")
            print(newTree.species)
            print(newTree.height)
            print(newTree.dap)
            print(newTree.totalCO2)
//            createPin()
            
            
            
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
    
    func createPin() {
        do {
            guard let treeImage else {
                errorMessage = "Nenhuma imagem disponível para identificar."
                return
            }
            guard let tree = self.tree else {
                errorMessage = "Árvore não foi criada."
                return
            }
            
            //TO DO: Pegar o user, nn sei como
            let newPin = try pinService.createPin(image: treeImage.pngData(), latitude: pinLatitude, longitude: pinLongitude, user: pinUser!, tree: tree)
            
            print("🌱 Árvore criada com sucesso: \(newPin)")

            
        } catch {
            errorMessage = "Ocorreu um erro ao criar o pino: \(error.localizedDescription)"
        }
        
    }
    
    func editScannedTree() {
        print("a")
    }
    
    func cancel() {
        print("a")
    }
    
    
}
