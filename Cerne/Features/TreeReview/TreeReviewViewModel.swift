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
    private var repository: TreeReviewRepositoryProtocol
    
    // Dados de entrada
    private var measuredDiameter: Double
    private var treeImage: UIImage?
    private var estimatedHeight: Double
    private var pinLatitude: Double
    private var pinLongitude: Double
    
    // Estado da View
    var tree: ScannedTree?
    var isLoading: Bool = false
    var errorMessage: String?
    var isEditing: Bool = false
    
    // Propriedades para edição
    var updateSpecies: String = ""
    var updateHeight: Double = 0.0
    var updateDap: Double = 0.0
    
    init(
        repository: TreeReviewRepositoryProtocol,
        measuredDiameter: Double,
        treeImage: UIImage?,
        estimatedHeight: Double,
        pinLatitude: Double,
        pinLongitude: Double
    ) {
        self.repository = repository
        self.measuredDiameter = measuredDiameter
        self.treeImage = treeImage
        self.estimatedHeight = estimatedHeight
        self.pinLatitude = pinLatitude
        self.pinLongitude = pinLongitude
    }
    
    func createScannedTree() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let image = treeImage else {
            errorMessage = "Nenhuma imagem disponível para identificar."
            return
        }
        
        do {
            let resultDTO = try await repository.createTreeAndPin(
                image: image,
                height: estimatedHeight,
                dap: measuredDiameter,
                latitude: pinLatitude,
                longitude: pinLongitude
            )
            
            self.tree = resultDTO.createdTree
            
            NotificationCenter.default.post(name: .didUpdateUserData, object: nil)            
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Ocorreu um erro ao criar a árvore: \(error.localizedDescription)"
        }
    }
    
    func updateScannedTree() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let currentTree = self.tree else {
            errorMessage = "Nenhuma árvore para atualizar."
            return
        }
        
        do {
            self.tree = try await repository.updateScannedTree(
                tree: currentTree,
                newSpecies: updateSpecies,
                newHeight: updateHeight,
                newDap: updateDap
            )
            
            NotificationCenter.default.post(name: .didUpdateUserData, object: nil)
        } catch {
            errorMessage = "Ocorreu um erro ao atualizar a árvore: \(error.localizedDescription)"
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
