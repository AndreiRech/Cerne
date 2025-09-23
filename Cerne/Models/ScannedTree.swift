//
//  Tree.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import Foundation
import SwiftData

@Model
final class ScannedTree: Identifiable {
    var id: UUID = UUID()
    var species: String = ""
    var height: Double = 0.0
    var dap: Double = 0.0
    var totalCO2: Double = 0.0
    
    var pin: Pin?
    
    init(id: UUID = UUID(), species: String, height: Double, dap: Double, totalCO2: Double) {
        self.id = id
        self.species = species
        self.height = height
        self.dap = dap
        self.totalCO2 = totalCO2
    }
}
