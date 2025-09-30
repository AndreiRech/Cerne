//
//  FootprintRepository.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation

class FootprintRepository: FootprintRepositoryProtocol {
    private let userService: UserServiceProtocol
    private let footprintService: FootprintServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    init(userService: UserServiceProtocol,
         footprintService: FootprintServiceProtocol,
         cacheService: CacheServiceProtocol = CacheService.shared) {
        self.userService = userService
        self.footprintService = footprintService
        self.cacheService = cacheService
    }
    
    func fetchFootprintData() async throws -> FootprintDTO {
        // 1. Realizando busca individual na cache
        let cachedUser: User? = cacheService.get(forKey: .currentUser)
        
        // 2. Realizando a chamada no banco para quem não estiver disponível
        async let userTask: User = {
            if let cachedUser {
                return cachedUser
            }
            return try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
        }()
        
        // 3. Aguardando as Tasks acabarem
        let finalUser = try await userTask
        
        // 4. Busca a footprint (depende do User)
        let finalFootprint: Footprint? = try await {
            if let cachedFootprint: Footprint = cacheService.get(forKey: .userFootprint) {
                if cachedFootprint.userRecordID?.recordName == finalUser.recordID?.recordName {
                    return cachedFootprint
                }
            }
            return try await footprintService.fetchFootprint(for: finalUser)
        }()
        
        var finalResponse: [Response] = []
        if let finalFootprint {
            finalResponse = try await {
                if let cachedResponse: [Response] = cacheService.get(forKey: .responses) {
                    return cachedResponse
                }
                return try await footprintService.fetchResponses(for: finalFootprint)
            }()
        }
        
        // 5. Monta o DTO
        let footprintData = FootprintDTO(currentUser: finalUser, userFootprint: finalFootprint, responses: finalResponse)
        
        // 6. Atualiza os dados
        cacheService.set(finalUser, forKey: .currentUser)
        
        if let footprintToCache = finalFootprint {
            cacheService.set(footprintToCache, forKey: .userFootprint)
            cacheService.set(finalResponse, forKey: .responses)
        } else {
            cacheService.remove(forKey: .userFootprint)
            cacheService.remove(forKey: .responses)
        }
        
        return footprintData
    }
    
    func saveFootprint(for user: User, with responses: [ResponseData]) async throws -> Footprint {
        let updatedFootprint = try await footprintService.createOrUpdateFootprint(for: user, with: responses)
        let newResponses = try await footprintService.fetchResponses(for: updatedFootprint)
        
        cacheService.set(updatedFootprint, forKey: .userFootprint)
        cacheService.set(newResponses, forKey: .responses)
        
        NotificationCenter.default.post(name: .didUpdateUserData, object: nil)
        
        return updatedFootprint
    }
    
    func getQuestions() throws -> [Question] {
        return try footprintService.getQuestions(fileName: "Questions")
    }
}
