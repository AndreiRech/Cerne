//
//  Response.swift
//  Cerne
//
//  Created by Andrei Rech on 05/09/25.
//

import Foundation
import CloudKit

struct Response: Identifiable {
    var recordID: CKRecord.ID?
    var id: UUID = UUID()
    var questionId: Int
    var optionId: Int
    var value: Double
    
    var footprintRecordID: CKRecord.ID?
    
    init(id: UUID = UUID(), questionId: Int, optionId: Int, value: Double, footprintRecordID: CKRecord.ID) {
        self.id = id
        self.questionId = questionId
        self.optionId = optionId
        self.value = value
        self.footprintRecordID = footprintRecordID
    }
    
    init?(record: CKRecord) {
        guard let idString = record["CD_id"] as? String,
              let id = UUID(uuidString: idString),
              let questionId = record["CD_questionId"] as? Int,
              let optionId = record["CD_optionId"] as? Int,
              let value = record["CD_value"] as? Double,
              let footprintRef = record["CD_footprint"] as? CKRecord.Reference else {
            return nil
        }
        
        self.recordID = record.recordID
        self.id = id
        self.questionId = questionId
        self.optionId = optionId
        self.value = value
        self.footprintRecordID = footprintRef.recordID
    }
}
