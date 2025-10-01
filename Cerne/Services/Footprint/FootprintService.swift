//
//  FootprintService.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import CloudKit

class FootprintService: FootprintServiceProtocol {
    private let publicDB = CKContainer.default().publicCloudDatabase
    
    init() {}
    
    func fetchFootprints() async throws -> [Footprint] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "CD_Footprint", predicate: predicate)
        
        do {
            let (matchResults, _) = try await publicDB.records(matching: query)
            let records = try matchResults.map { try $0.1.get() }
            return records.compactMap { Footprint(record: $0) }
        } catch {
            throw GenericError.serviceError
        }
    }
    
    func fetchFootprint(for user: User) async throws -> Footprint? {
        guard let userRecordID = user.recordID else {
            throw GenericError.serviceError
        }
        
        let userReference = CKRecord.Reference(recordID: userRecordID, action: .none)
        let predicate = NSPredicate(format: "CD_user == %@", userReference)
        let query = CKQuery(recordType: "CD_Footprint", predicate: predicate)
        
        do {
            let (matchResults, _) = try await publicDB.records(matching: query)
            let records = try matchResults.map { try $0.1.get() }
            return records.compactMap { Footprint(record: $0) }.first
        } catch {
            print("Erro detalhado do CloudKit em fetchFootprint: \(error)")
            print("Erro ao buscar footprints: \(error.localizedDescription)")
            throw GenericError.serviceError
        }
    }
    
    func fetchResponses(for footprint: Footprint) async throws -> [Response] {
        guard let footprintRecordID = footprint.recordID else {
            return []
        }
        
        let footprintReference = CKRecord.Reference(recordID: footprintRecordID, action: .none)
        let predicate = NSPredicate(format: "CD_footprint == %@", footprintReference)
        let query = CKQuery(recordType: "CD_Response", predicate: predicate)
        
        do {
            let (matchResults, _) = try await publicDB.records(matching: query)
            let records = try matchResults.map { try $0.1.get() }
            return records.compactMap { Response(record: $0) }
        } catch {
            print("Erro detalhado do CloudKit em fetchResponses: \(error)")
            print("Erro ao buscar responses: \(error.localizedDescription)")
            throw GenericError.serviceError
        }
    }
    
    func createOrUpdateFootprint(for user: User, with responsesData: [ResponseData]) async throws -> Footprint {
        guard let userRecordID = user.recordID else {
            throw GenericError.serviceError
        }
        
        let newTotal = responsesData.reduce(0) { $0 + $1.value }
        
        var existingFootprint: Footprint?
        do {
            existingFootprint = try await fetchFootprint(for: user)
        } catch  {
            existingFootprint = nil
        }
        
        var footprintRecord: CKRecord
        
        if let existingFootprint, let existingRecordID = existingFootprint.recordID {
            let oldResponses = try await fetchResponses(for: existingFootprint)
            let oldResponseIDs = oldResponses.compactMap { $0.recordID }
            if !oldResponseIDs.isEmpty {
                _ = try await publicDB.modifyRecords(saving: [], deleting: oldResponseIDs)
            }
            
            footprintRecord = try await publicDB.record(for: existingRecordID)
            footprintRecord["CD_total"] = newTotal
            footprintRecord = try await publicDB.save(footprintRecord)
            
        } else {
            let newFootprintRecord = CKRecord(recordType: "CD_Footprint")
            newFootprintRecord["CD_id"] = UUID().uuidString
            newFootprintRecord["CD_total"] = newTotal
            newFootprintRecord["CD_user"] = CKRecord.Reference(recordID: userRecordID, action: .none)
            footprintRecord = try await publicDB.save(newFootprintRecord)
        }
        
        let footprintReference = CKRecord.Reference(recordID: footprintRecord.recordID, action: .deleteSelf)
        var newResponseRecords: [CKRecord] = []
        
        for responseData in responsesData {
            let responseRecord = CKRecord(recordType: "CD_Response")
            responseRecord["CD_id"] = UUID().uuidString
            responseRecord["CD_questionId"] = responseData.questionId
            responseRecord["CD_optionId"] = responseData.optionId
            responseRecord["CD_value"] = responseData.value
            responseRecord["CD_footprint"] = footprintReference
            newResponseRecords.append(responseRecord)
        }
        
        if !newResponseRecords.isEmpty {
            _ = try await publicDB.modifyRecords(saving: newResponseRecords, deleting: [])
        }
        
        guard let finalFootprint = Footprint(record: footprintRecord) else {
            throw GenericError.serviceError
        }
        return finalFootprint
    }
    
    func getQuestions(fileName: String) throws -> [Question] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw JsonError.fileNotFound
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw JsonError.errorLoadingData
        }
        
        let decoder = JSONDecoder()
        
        do {
            let questions = try decoder.decode([Question].self, from: data)
            return questions
        } catch {
            throw JsonError.invalidJsonFormat
        }
    }
    
    func deleteFootprint(_ footprint: Footprint) async throws {
        guard let recordID = footprint.recordID else {
            throw GenericError.serviceError
        }
        
        do {
            try await publicDB.deleteRecord(withID: recordID)
        } catch {
            print("Erro ao deletar Footprint: \(error.localizedDescription)")
            throw GenericError.serviceError
        }
    }
}
