//
//  Pin.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import Foundation
import CloudKit
import UIKit

struct Pin: Identifiable {
    var recordID: CKRecord.ID?
    var id: UUID = UUID()
    var imageAsset: CKAsset?
    var latitude: Double
    var longitude: Double
    var date: Date
    var reports: Int
    
    var userRecordID: CKRecord.ID?
    var treeRecordID: CKRecord.ID?
    
    var image: UIImage? {
        guard let imageAsset, let fileURL = imageAsset.fileURL, let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    init(id: UUID = UUID(), image: UIImage, latitude: Double, longitude: Double, date: Date, userRecordID: CKRecord.ID, treeRecordID: CKRecord.ID) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.reports = 0
        self.userRecordID = userRecordID
        self.treeRecordID = treeRecordID
        
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        if let jpegData = image.jpegData(compressionQuality: 0.7) {
            try? jpegData.write(to: tempURL)
            self.imageAsset = CKAsset(fileURL: tempURL)
        }
    }
    
    init?(record: CKRecord) {
        guard let idString = record["CD_id"] as? String,
              let id = UUID(uuidString: idString),
              let imageAsset = record["CD_image"] as? CKAsset,
              let latitude = record["CD_latitude"] as? Double,
              let longitude = record["CD_longitude"] as? Double,
              let date = record["CD_date"] as? Date,
              let reports = record["CD_reports"] as? Int,
              let userRef = record["CD_user"] as? CKRecord.Reference,
              let treeRef = record["CD_tree"] as? CKRecord.Reference else {
            return nil
        }
        
        self.recordID = record.recordID
        self.id = id
        self.imageAsset = imageAsset
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.reports = reports
        self.userRecordID = userRef.recordID
        self.treeRecordID = treeRef.recordID
    }
}
