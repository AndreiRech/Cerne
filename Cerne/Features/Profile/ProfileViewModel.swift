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
    
    var userName: String = " "
    var userPins: [Pin] = []
    var footprint: String?
    var isLoading: Bool = true
    var totalCO2: String = "0"
    var isShowingDeleteAlert = false
    var annualData: [MonthlyData] = []
    var monthlyObjective: Int = 0
    var annualObjective: Double = 0.0
    
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
            self.userName = user?.name ?? " "
            
            if let userFootprint = data.userFootprint {
                let totalInKg = userFootprint.total
                self.footprint = String(format: "%.0f Kg", totalInKg)
                self.annualObjective = totalInKg
                self.monthlyObjective = Int(totalInKg / 12)
            } else {
                self.userFootprint = nil
                self.annualObjective = 0
                self.monthlyObjective = 0
            }
            
            self.userPins = []
            self.userPins = data.allPins.filter { $0.userRecordID == data.currentUser.recordID }
            
            var total: Double = 0.0
            for pin in data.allPins {
                if let tree = getTree(for: pin) {
                    total += tree.totalCO2
                }
            }
            self.totalCO2 = String(format: "%.0f", total)

            calculateAnnualProgress()
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
    
    func CO2AnualPercent() -> Int {
        if annualObjective == 0 {
            return 0
        }
            
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())

        let currentYearPins = userPins.filter {
            calendar.component(.year, from: $0.date) == currentYear
        }
        let totalNeutralized = currentYearPins.compactMap { pin in
            getTree(for: pin)?.totalCO2
        }.reduce(0, +)

        let percentage = (totalNeutralized / annualObjective) * 100.0
            
        let finalPercentage = Int(round(max(0, min(percentage, 100.0))))
            
        return finalPercentage
    }
    
    func calculateAnnualProgress() {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        var monthlyTotals = Array(repeating: 0.0, count: 12)

        let currentYearPins = userPins.filter {
            calendar.component(.year, from: $0.date) == currentYear
        }

        for pin in currentYearPins {
            let month = calendar.component(.month, from: pin.date) - 1
            if month >= 0 && month < 12 {
                if let tree = getTree(for: pin) {
                    monthlyTotals[month] += tree.totalCO2
                }
            }
        }

        let monthSymbols = calendar.shortMonthSymbols.map { String($0.prefix(1)) }
        let objective = Double(monthlyObjective)
            
        self.annualData = monthlyTotals.enumerated().map { (index, total) -> MonthlyData in
            var normalizedHeight = 0.0
            
            if objective > 0 {
                let percentage = total / objective
                normalizedHeight = min(percentage, 1.0)
            }
                    
            return MonthlyData(month: monthSymbols[index], normalizedHeight: normalizedHeight)
        }
    }
}
