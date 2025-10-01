//
//  MockFootprintRepository.swift
//  Cerne
//
//  Created by Andrei Rech on 01/10/25.
//

import Foundation
@testable import Cerne

class MockFootprintRepository: FootprintRepositoryProtocol {
    var shouldFail: Bool = false
    var saveFootprintCalled: Bool = false
    
    let mockUserService: MockUserService
    let mockFootprintService: MockFootprintService
    let mockCacheService: MockCacheService
    
    init(
        shouldFail: Bool = false,
        mockUserService: MockUserService = MockUserService(),
        mockFootprintService: MockFootprintService = MockFootprintService(),
        mockCacheService: MockCacheService = MockCacheService()
    ) {
        self.shouldFail = shouldFail
        self.mockUserService = mockUserService
        self.mockFootprintService = mockFootprintService
        self.mockCacheService = mockCacheService
    }
    
    func fetchFootprintData() async throws -> FootprintDTO {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        let user = try await mockUserService.fetchOrCreateCurrentUser(name: nil, height: nil)
        let footprint = try await mockFootprintService.fetchFootprint(for: user)
        var responses: [Response] = []
        if let footprint = footprint {
            responses = try await mockFootprintService.fetchResponses(for: footprint)
        }
        
        return FootprintDTO(currentUser: user, userFootprint: footprint, responses: responses)
    }
    
    func saveFootprint(for user: User, with responses: [ResponseData]) async throws -> Footprint {
        saveFootprintCalled = true
        if shouldFail {
            throw GenericError.serviceError
        }
        
        let savedFootprint = try await mockFootprintService.createOrUpdateFootprint(for: user, with: responses)
        return savedFootprint
    }
    
    func getQuestions() throws -> [Question] {
        if shouldFail {
            throw JsonError.fileNotFound
        }
        return try mockFootprintService.getQuestions(fileName: "Questions")
    }
}
