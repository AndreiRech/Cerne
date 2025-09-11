//
//  MockFootprintService.swift
//  CerneTests
//
//  Created by Gabriel Kowaleski on 09/09/25.
//

@testable import Cerne
import Foundation
import SwiftData

class MockFootprintService: FootprintServiceProtocol {
    var footprints: [UUID: Footprint] = [:]
    var shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func createOrUpdateFootprint(for user: User, with newResponses: [Response]) throws {
        if shouldFail {
            throw NSError(domain: "MockFootprintService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create or update Footprint"])
        }
        
        let newTotal = newResponses.reduce(0) { $0 + $1.value }
        
        if let existingFootprint = footprints[user.id] {
            existingFootprint.responses = newResponses
            existingFootprint.total = newTotal
        } else {
            let newFootprint = Footprint(total: newTotal, responses: newResponses)
            footprints[user.id] = newFootprint
            
            user.footprint = newFootprint
        }
    }
    
    func getQuestions(fileName: String) throws -> [Question] {
        if shouldFail {
            throw JsonError.fileNotFound
        }
        
        return [Question(id: 1, text: "Question", options: [Option(id: 1, text: "Pergunta", value: 1)])]
    }
}
