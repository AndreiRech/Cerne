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
    
    private let pinService: PinServiceProtocol
    private let userService: UserServiceProtocol
    private let userDefaultService: UserDefaultServiceProtocol
    private let treeService: ScannedTreeServiceProtocol
    
    var allDetails: [TreeDetails] = []
    var details: TreeDetails?
    
    var isPinFromUser: Bool = false
    var errorMessage: String?
    var reportEnabled: Bool = true
    
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
        await fetchTreeAndUser()
        setupDetails()
        await isPinFromUser()
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
            _ = try await pinService.addReport(to: pin)
            userDefaultService.setPinReported(pin: pin)
            reportEnabled = false
        } catch {
            errorMessage = "Failed to report pin"
        }
    }
    
    func isPinFromUser() async {
        do {
            let currentUser = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            
            isPinFromUser = currentUser.recordID == pinUser?.recordID
        } catch {
            errorMessage = "Failed to get user for pin"
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
        guard let treeRef = pin.treeRecordID, let _ = pin.userRecordID else {
            errorMessage = "Pin does not contain tree or user reference."
            return
        }
        
        do {
            async let fetchedTree = treeService.fetchScannedTree(treeID: treeRef)
            async let fetchedUser = userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            
            self.tree = try await fetchedTree
            self.pinUser = try await fetchedUser
            
        } catch {
            errorMessage = "Failed to fetch Tree or User for the Pin."
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
