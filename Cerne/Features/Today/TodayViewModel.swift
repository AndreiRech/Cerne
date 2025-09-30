//
//  TodayViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import Foundation

@Observable
@MainActor
class TodayViewModel: TodayViewModelProtocol {    
    var pinService: PinServiceProtocol
    var userService: UserServiceProtocol
    var footprintService: FootprintServiceProtocol
    var treeService: ScannedTreeServiceProtocol
    
    private var user: User?
    private var allTrees: [ScannedTree] = []
    
    var userPins: [Pin] = []
    var allPins: [Pin] = []
    var userName: String = ""
    
    private var totalCO2Double: Double = 0.0
    var totalCO2: String {
        String(format: "%.0f", totalCO2Double)
    }
    
    var isShowingShareSheet: Bool = false
    var isLoading: Bool = false
    
    var month: String = Date().formatted(.dateTime.month(.wide).locale(Locale(identifier: "pt_BR"))).capitalized
    var monthlyObjective: Int = 0
    
    init(pinService: PinServiceProtocol, userService: UserServiceProtocol, footprintService: FootprintServiceProtocol, treeService: ScannedTreeServiceProtocol) {
        self.pinService = pinService
        self.userService = userService
        self.footprintService = footprintService
        self.treeService = treeService
    }
    
    func fetchInformation() async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        self.userPins = []
        self.allPins = []
        self.allTrees = []

        do {
            self.user = try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
            self.allPins = try await pinService.fetchPins()
            self.allTrees = try await treeService.fetchScannedTrees()

            userName = user?.name ?? "Usuario"

            for pin in allPins {
                if pin.userRecordID == user?.recordID {
                    self.userPins.append(pin)
                }

                for scannedTree in allTrees {
                    if pin.treeRecordID == scannedTree.recordID {
                        totalCO2Double += scannedTree.totalCO2
                    }
                }
            }
        } catch {
            print("Erro ao buscar os pins do usuário: \(error.localizedDescription)")
            self.userPins = []
            self.allPins = []
            self.allTrees = []
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
    
    func calculateMonthlyObjective() async {
        do {
            guard let user else { return }
            
            if let userFootprint = try await footprintService.fetchFootprint(for: user) {
                self.monthlyObjective = Int(userFootprint.total / 12)
            }
        } catch {
            print("Erro ao calcular o objetivo do mês: \(error.localizedDescription)")
            self.monthlyObjective = 0
        }
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
}

