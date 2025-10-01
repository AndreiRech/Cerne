//
//  MockFootprintService.swift
//  CerneTests
//
//  Created by Gabriel Kowaleski on 09/09/25.
//

@testable import Cerne
import Foundation
import CloudKit

class MockFootprintService: FootprintServiceProtocol {
    var footprints: [Footprint]
    var responses: [Response]
    
    var shouldFail: Bool
    
    init(shouldFail: Bool = false, initialFootprints: [Footprint] = [], initialResponses: [Response] = []) {
        self.shouldFail = shouldFail
        self.footprints = initialFootprints
        self.responses = initialResponses
    }
    
    func fetchFootprints() async throws -> [Footprint] {
        if shouldFail {
            throw GenericError.serviceError
        }
        return footprints
    }
    
    func fetchFootprint(for user: User) async throws -> Footprint? {
        if shouldFail {
            throw GenericError.serviceError
        }
        guard let userRecordID = user.recordID else {
            return nil
        }
        
        return footprints.first { $0.userRecordID == userRecordID }
    }
    
    func fetchResponses(for footprint: Footprint) async throws -> [Response] {
        if shouldFail {
            throw GenericError.serviceError
        }
        guard let footprintRecordID = footprint.recordID else {
            return []
        }
        
        return responses.filter { $0.footprintRecordID == footprintRecordID }
    }
    
    func createOrUpdateFootprint(for user: User, with responsesData: [ResponseData]) async throws -> Footprint {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        guard let userRecordID = user.recordID else {
            throw GenericError.serviceError
        }
        
        let newTotal = responsesData.reduce(0) { $0 + $1.value }
        
        var finalFootprint: Footprint
        
        if let existingFootprint = try await fetchFootprint(for: user), let footprintIndex = footprints.firstIndex(where: { $0.id == existingFootprint.id }) {
            responses.removeAll { $0.footprintRecordID == existingFootprint.recordID }
            
            footprints[footprintIndex].total = newTotal
            finalFootprint = footprints[footprintIndex]
            
        } else {
            let newFootprint = Footprint(id: UUID(), total: newTotal, userRecordID: userRecordID)
            footprints.append(newFootprint)
            finalFootprint = newFootprint
        }
        
        for responseData in responsesData {
            let newResponse = Response(id: UUID(), questionId: responseData.questionId, optionId: responseData.optionId, value: responseData.value, footprintRecordID: finalFootprint.recordID!)
            responses.append(newResponse)
        }
        
        return finalFootprint
    }

    func getQuestions(fileName: String) throws -> [Question] {
        if shouldFail {
            throw JsonError.fileNotFound
        }
        
        return [
            Question(id: 1, text: "Qual seu meio de transporte principal?", options: [
                Option(id: 1, text: "Carro", value: 5.0),
                Option(id: 2, text: "Transporte Público", value: 2.0),
                Option(id: 3, text: "Bicicleta ou a pé", value: 0.5)
            ])
        ]
    }
    
    func deleteFootprint(_ footprint: Footprint) async throws {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        guard let recordID = footprint.recordID else {
            return
        }
        
        responses.removeAll { $0.footprintRecordID == recordID }
        footprints.removeAll { $0.recordID == recordID }
    }
}
