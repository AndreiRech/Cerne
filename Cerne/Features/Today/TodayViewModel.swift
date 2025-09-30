//
//  TodayViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import Foundation

@Observable
class TodayViewModel: TodayViewModelProtocol {
    private var repository: TodayRepositoryProtocol
    
    var userPins: [Pin] = []
    var allPins: [Pin] = []
    var userName: String = ""
    var userFootprint: Footprint?
    private var allTrees: [ScannedTree] = []
    
    private var totalCO2Double: Double = 0.0
    var totalCO2: String { String(format: "%.0f", totalCO2Double) }
    
    var isShowingShareSheet: Bool = false
    var isLoading: Bool = false
    
    var month: String = Date().formatted(.dateTime.month(.wide).locale(Locale(identifier: "pt_BR"))).capitalized
    var monthlyObjective: Int = 0
    
    init(repository: TodayRepositoryProtocol) {
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
            let data = try await repository.fetchTodayData()
            
            self.userName = data.currentUser.name
            self.allPins = data.allPins
            self.allTrees = data.allTrees
            
            if let userFootprint = data.userFootprint {
                self.monthlyObjective = Int(userFootprint.total / 12)
            } else {
                self.userFootprint = nil
                self.monthlyObjective = 0
            }
            
            self.userPins = []
            self.totalCO2Double = 0.0
            
            self.userPins = data.allPins.filter { $0.userRecordID == data.currentUser.recordID }
            
            for pin in data.allPins {
                if let tree = getTree(for: pin) {
                    totalCO2Double += tree.totalCO2
                }
            }
            
        } catch {
            print("Erro ao buscar dados do repositório: \(error.localizedDescription)")
        }
    }
    
    func totalCO2Sequestration() -> Double {
        return totalCO2Double / 1000.0
    }
    
    func totalO2() -> Double {
        return (totalCO2Double / 44.0) * 32.0 / 1000.0
    }
    
    func lapsEarth(totalCO2: Double) -> Double {
        let laps = totalCO2 * 0.108
        return laps
    }
    
    func oxygenPerPerson(totalOxygen: Double) -> Int {
        let oxygenPerPerson = totalOxygen * 3.5
        return Int(oxygenPerPerson.rounded())
    }
    
    func percentageCO2User() -> Int {
        let totalCO2User = neutralizedAmountThisMonth()
        let objective = Double(monthlyObjective)
        
        if objective == 0 {
            return 0
        }
        var total = Int((totalCO2User / objective) * 100.0)
        if total > 100 {
            total = 100
        }
        return total
    }
    
    func neutralizedAmountThisMonth() -> Double {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        let pinsThisMonth = userPins.filter { pin in
            let pinMonth = calendar.component(.month, from: pin.date)
            let pinYear = calendar.component(.year, from: pin.date)
            return pinMonth == currentMonth && pinYear == currentYear
        }
        
        var total: Double = 0.0
        for pin in pinsThisMonth {
            for scannedTree in allTrees {
                if pin.treeRecordID == scannedTree.recordID {
                    total += scannedTree.totalCO2
                }
            }
        }
        return total
    }
    
    func showShareSheet() {
        self.isShowingShareSheet = true
    }
    
    var totalTrees: Int {
        allPins.count
    }
    
    var totalSpecies: Int {
        var species: Set<String> = []
        
        for pin in allPins {
            for scannedTree in allTrees {
                if pin.treeRecordID == scannedTree.recordID {
                    species.insert(scannedTree.species)
                }
            }
        }
        return species.count
    }
    
    func getTree(for pin: Pin) -> ScannedTree? {
        return allTrees.first { tree in tree.recordID == pin.treeRecordID }
    }
    
    @objc private func userDataDidUpdate() {
        Task { @MainActor in
            await fetchData()
        }
    }
}

