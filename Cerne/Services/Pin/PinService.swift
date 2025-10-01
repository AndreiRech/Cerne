//
//  PinService.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import CloudKit
import UIKit

class PinService: PinServiceProtocol {
    private let publicDB = CKContainer.default().publicCloudDatabase
    var details: [TreeDetails]

    init(details: [TreeDetails] = []) {
        self.details = []
    }

    func fetchPins() async throws -> [Pin] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "CD_Pin", predicate: predicate)
        
        do {
            let (matchResults, _) = try await publicDB.records(matching: query)
            let records = try matchResults.map { try $0.1.get() }
            
            return records.compactMap { Pin(record: $0) }
        } catch {
            print("Erro detalhado do CloudKit em fetchPins: \(error)")
            print("Erro ao buscar Pins: \(error.localizedDescription)")
            throw GenericError.serviceError
        }
    }
    
    func createPin(image: UIImage, latitude: Double, longitude: Double, user: User, tree: ScannedTree) async throws -> Pin {
        guard let userRecordID = user.recordID, let treeRecordID = tree.recordID else {
            throw GenericError.serviceError
        }

        let newPin = Pin(image: image, latitude: latitude, longitude: longitude, date: Date(), userRecordID: userRecordID, treeRecordID: treeRecordID)
        
        let pinRecord = CKRecord(recordType: "CD_Pin")
        pinRecord["CD_id"] = newPin.id.uuidString
        pinRecord["CD_image"] = newPin.imageAsset
        pinRecord["CD_latitude"] = newPin.latitude
        pinRecord["CD_longitude"] = newPin.longitude
        pinRecord["CD_date"] = newPin.date
        pinRecord["CD_reports"] = newPin.reports
        
        pinRecord["CD_user"] = CKRecord.Reference(recordID: userRecordID, action: .none)
        pinRecord["CD_tree"] = CKRecord.Reference(recordID: treeRecordID, action: .deleteSelf)
        
        do {
            let savedRecord = try await publicDB.save(pinRecord)
            let treeRecordToUpdate = try await publicDB.record(for: treeRecordID)
            
            treeRecordToUpdate["CD_pin"] = CKRecord.Reference(record: savedRecord, action: .deleteSelf)
            
            _ = try await publicDB.save(treeRecordToUpdate)
            
            guard let savedPin = Pin(record: savedRecord) else {
                throw GenericError.serviceError
            }
            return savedPin
            
        } catch {
            print("Erro detalhado do CloudKit em createPin: \(error)")
            print("Erro ao criar Pins: \(error.localizedDescription)")
            throw GenericError.serviceError
        }
    }
    
    func addReport(to pin: Pin) async throws -> Pin? {
        guard let recordID = pin.recordID else {
            throw GenericError.serviceError
        }
        
        do {
            let recordToUpdate = try await publicDB.record(for: recordID)
            
            var currentReports = recordToUpdate["CD_reports"] as? Int ?? 0
            currentReports += 1
            if currentReports >= 5 {
                try await deletePin(pin)
                return nil
            }
            
            recordToUpdate["CD_reports"] = currentReports
            let updatedRecord = try await publicDB.save(recordToUpdate)
            return Pin(record: updatedRecord)
        } catch {
            throw GenericError.serviceError
        }
    }
    
    func deletePin(_ pin: Pin) async throws {
        guard let recordID = pin.recordID else {
            throw GenericError.serviceError
        }
        
        do {
            try await publicDB.deleteRecord(withID: recordID)
        } catch {
            throw GenericError.serviceError
        }
    }

    func getDetails(fileName: String) throws -> [TreeDetails] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw JsonError.fileNotFound
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw JsonError.errorLoadingData
        }
        
        let decoder = JSONDecoder()
        
        do {
            let details = try decoder.decode([TreeDetails].self, from: data)
            self.details = details
            return details
        } catch {
            throw JsonError.invalidJsonFormat
        }
    }
    
    func getDetails(for tree: ScannedTree) throws -> TreeDetails {
        let treeName = tree.species.lowercased()
        
        for detail in details {
            if detail.scientificName.lowercased().contains(treeName) {
                return detail
            }
        }
        
        throw GenericError.detailsNotFound
    }
}
