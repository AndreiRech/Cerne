//
//  ProfileViewModel.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 26/09/25.
//

import Foundation

@Observable
class ProfileViewModel: ProfileViewModelProtocol {
    private var repository: ProfileRepositoryProtocol
    
    private var user: User?
    private var userFootprint: Footprint?
    private var allPins: [Pin] = []
    private var allTrees: [ScannedTree] = []
    
    var userPins: [Pin] = []
    var footprint: String?
    var isLoading: Bool = true
    var totalCO2: String = "0"
    var isShowingDeleteAlert = false
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDataDidUpdate),
            name: .didUpdateUserData,
            object: nil
        )
    }
    
    func fetchData() async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            let data = try await repository.fetchProfileData()
            
            self.user = data.currentUser
            self.allPins = data.allPins
            self.allTrees = data.allTrees
            
            if let userFootprint = data.userFootprint {
                let totalInKg = userFootprint.total
                self.footprint = String(format: "%.0f Kg", totalInKg)
            } else {
                self.userFootprint = nil
            }
            
            self.userPins = []
            self.userPins = data.allPins.filter { $0.userRecordID == data.currentUser.recordID }
            
            var total: Double = 0.0
            for pin in data.allPins {
                if let tree = getTree(for: pin) {
                    total += tree.totalCO2
                }
            }
            totalCO2 = String(format: "%.0f", total)
        } catch {
            print("Erro ao buscar dados do repositório: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            guard let user = self.user else { return }
            
            try await repository.deleteAccount(for: user)
        } catch {
            print("Erro ao deletar o usuário: \(error.localizedDescription)")
        }
    }
    
    private func getTree(for pin: Pin) -> ScannedTree? {
        return allTrees.first { tree in tree.recordID == pin.treeRecordID }
    }
    
    @objc private func userDataDidUpdate() {
        Task { @MainActor in
            await fetchData()
        }
    }
}
