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
    var footprints: [Footprint]
    var shouldFail: Bool
    
    init(shouldFail: Bool = false, footprints: [Footprint] = [Footprint(id: UUID(), total: 2.0, responses: [Response(questionId: 1, optionId: 1, value: 2.0)])]) {
        self.shouldFail = shouldFail
        self.footprints = footprints
    }
    
    func fetchFootprints() throws -> [Footprint] {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        return footprints
    }
    
    func createOrUpdateFootprint(for user: User, with newResponses: [Response]) throws {
        if shouldFail {
            throw NSError(domain: "MockFootprintService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create or update Footprint"])
        }
        
        let newTotal = newResponses.reduce(0) { $0 + $1.value }
        
        user.footprint = Footprint(id: UUID(), total: newTotal, responses: newResponses)
    }
    
    func getQuestions(fileName: String) throws -> [Question] {
        if shouldFail {
            throw JsonError.fileNotFound
        }
        
        return [Question(id: 1, text: "Question", options: [Option(id: 1, text: "Pergunta", value: 1)])]
    }
}
