//
//  PinDetailsViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 10/09/25.
//

import Foundation

@Observable
class PinDetailsViewModel: PinDetailsViewModelProtocol {
    var pin: Pin
    var tree: ScannedTree?
    var pinUser: User?
    var user: User?
    
    private let pinService: PinServiceProtocol
    private let userService: UserServiceProtocol
    private let userDefaultService: UserDefaultServiceProtocol
    private let treeService: ScannedTreeServiceProtocol
    
    var allDetails: [TreeDetails] = []
    var details: TreeDetails?
    
    var isPinFromUser: Bool = false
    var errorMessage: String?
    var reportEnabled: Bool = true
    var isLoading: Bool = true
    
    var formattedTotalCO2: String {
        return String(format: "%.0f", tree?.totalCO2 ?? 0.0)
    }
    
    init(pin: Pin, pinService: PinServiceProtocol, userService: UserServiceProtocol, userDefaultService: UserDefaultServiceProtocol, treeService: ScannedTreeServiceProtocol) {
        self.pin = pin
        self.pinService = pinService
        self.userService = userService
        self.userDefaultService = userDefaultService
        self.treeService = treeService
        
        getDetails()
    }
    
    func fetchData() async {
        isLoading = true
        defer { self.isLoading = false }
        
        await fetchTreeAndUser()
        setupDetails()
        updateReportStatus()
    }
    
    func deletePin() async {
        do {
            try await pinService.deletePin(pin)
        } catch {
            errorMessage = "Failed to delete pin"
        }
    }
    
    func reportPin() async {
        guard reportEnabled else { return }
        
        do {
            let updatedPin = try await pinService.addReport(to: pin)
            
            if let newPin = updatedPin {
                self.pin = newPin
                userDefaultService.setPinReported(pin: newPin)
                reportEnabled = false
            } else {
                print("erro ao denunciar o pin")
            }
        } catch {
            errorMessage = "Failed to report pin"
        }
    }
    
    func message() -> String {
        let co2 = tree?.totalCO2 ?? 0.0
        
        if co2 < 300 {
            let carEmissionsPerKm = 0.17
            let equivalentKm = co2 / carEmissionsPerKm
            let formattedKm = String(format: "%.1f", equivalentKm)
            
            return "A captura dessa árvore equivale a emissão de um carro, movido a gasolina, rodando \(formattedKm) km"
        } else if co2 < 600 {
            let truckEmissionsPerKm = 1.0
            let equivalentKm = co2 / truckEmissionsPerKm
            let formattedKm = String(format: "%.1f", equivalentKm)
            
            return "A captura dessa árvore equivale à emissão de um caminhão a diesel rodando cerca de \(formattedKm) km."
        } else {
            let airplaneEmissionsPerHour = 90.0
            let equivalentHours = co2 / airplaneEmissionsPerHour
            let formattedHours = String(format: "%.1f", equivalentHours)
            
            return "A captura dessa árvore equivale à emissão de um voo comercial de aproximadamente \(formattedHours) horas."
        }
    }
    
    private func isAbleToReport(pin: Pin) -> Bool {
        return userDefaultService.isPinReported(pin: pin) ? false : true
    }
    
    private func fetchTreeAndUser() async {
        guard let treeRef = pin.treeRecordID, let userRef = pin.userRecordID else {
            errorMessage = "O pino não contém referência à árvore ou ao utilizador."
            return
        }
        
        do {
            async let fetchedTree = treeService.fetchScannedTree(treeID: treeRef)
            async let fetchedPinUser = userService.fetchUser(by: userRef)
            
            self.tree = try await fetchedTree
            self.pinUser = try await fetchedPinUser
            
            self.user = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            
            isPinFromUser = user?.recordID == pinUser?.recordID
        } catch {
            errorMessage = "Falha ao buscar a Árvore ou o Utilizador para o Pino."
        }
    }
    
    private func getDetails() {
        do {
            allDetails = try pinService.getDetails(fileName: "Tree")
        } catch {
            errorMessage = "Failed to get details - Tree does not exist in JSON"
        }
    }
    
    private func setupDetails() {
        guard let tree = self.tree else { return }
        details = allDetails.first(where: { $0.scientificName.lowercased().contains(tree.species.lowercased()) })
        if details == nil {
            errorMessage = "Failed to get details - Tree does not exist in JSON"
        }
    }
    
    private func updateReportStatus() {
        self.reportEnabled = isAbleToReport(pin: pin)
    }
}
