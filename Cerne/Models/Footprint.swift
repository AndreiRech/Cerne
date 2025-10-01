//
//  Footprint.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import Foundation
import CloudKit

struct Footprint: Identifiable {
    var recordID: CKRecord.ID?
    var id: UUID = UUID()
    var total: Double
    
    var userRecordID: CKRecord.ID?

    init(id: UUID = UUID(), total: Double, userRecordID: CKRecord.ID) {
        self.id = id
        self.total = total
        self.userRecordID = userRecordID
    }
    
    init?(record: CKRecord) {
        guard let idString = record["CD_id"] as? String,
              let id = UUID(uuidString: idString),
              let total = record["CD_total"] as? Double,
              let userRef = record["CD_user"] as? CKRecord.Reference else {
            return nil
        }
        
        self.recordID = record.recordID
        self.id = id
        self.total = total
        self.userRecordID = userRef.recordID
    }
}
