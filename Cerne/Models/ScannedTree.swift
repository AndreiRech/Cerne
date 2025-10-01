//
//  Tree.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import Foundation
import CloudKit

struct ScannedTree: Identifiable {
    var recordID: CKRecord.ID?
    var id: UUID = UUID()
    var species: String
    var height: Double
    var dap: Double
    var totalCO2: Double
    
    init(id: UUID = UUID(), species: String, height: Double, dap: Double, totalCO2: Double) {
        self.id = id
        self.species = species
        self.height = height
        self.dap = dap
        self.totalCO2 = totalCO2
    }
    
    init?(record: CKRecord) {
        guard let idString = record["CD_id"] as? String,
              let id = UUID(uuidString: idString),
              let species = record["CD_species"] as? String,
              let height = record["CD_height"] as? Double,
              let dap = record["CD_dap"] as? Double,
              let totalCO2 = record["CD_totalCO2"] as? Double else {
            return nil
        }
        
        self.recordID = record.recordID
        self.id = id
        self.species = species
        self.height = height
        self.dap = dap
        self.totalCO2 = totalCO2
    }
}
