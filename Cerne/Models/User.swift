//
//  User.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import Foundation
import CloudKit

struct User: Identifiable {
    var recordID: CKRecord.ID?
    var id: String
    var name: String
    var height: Double
    
    init(id: String, name: String, height: Double) {
        self.id = id
        self.name = name
        self.height = height
    }
    
    init?(record: CKRecord) {
        guard let id = record["CD_id"] as? String,
              let name = record["CD_name"] as? String,
              let height = record["CD_height"] as? Double else {
            return nil
        }
        
        self.recordID = record.recordID
        self.id = id
        self.name = name
        self.height = height
    }
}
