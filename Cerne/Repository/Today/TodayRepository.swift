//
//  TodayRepository.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation

class TodayRepository: TodayRepositoryProtocol {
    private let pinService: PinServiceProtocol
    private let userService: UserServiceProtocol
    private let treeService: ScannedTreeServiceProtocol
    private let footprintService: FootprintServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    init(pinService: PinServiceProtocol,
         userService: UserServiceProtocol,
         treeService: ScannedTreeServiceProtocol,
         footprintService: FootprintServiceProtocol,
         cacheService: CacheServiceProtocol = CacheService.shared) {
        self.pinService = pinService
        self.userService = userService
        self.treeService = treeService
        self.footprintService = footprintService
        self.cacheService = cacheService
    }
    
    func fetchTodayData() async throws -> TodayDTO {
        // 1. Realizando busca individual na cache
        let cachedUser: User? = cacheService.get(forKey: .currentUser)
        let cachedPins: [Pin]? = cacheService.get(forKey: .allPins)
        let cachedTrees: [ScannedTree]? = cacheService.get(forKey: .allScannedTrees)
        
        // 2. Realizando a chamada no banco para quem não estiver disponível
        async let userTask: User = {
            if let cachedUser {
                return cachedUser
            }
            return try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
        }()
        
        async let pinsTask: [Pin] = {
            if let cachedPins {
                return cachedPins
            }
            return try await pinService.fetchPins()
        }()
        
        async let treesTask: [ScannedTree] = {
            if let cachedTrees {
                return cachedTrees
            }
            return try await treeService.fetchScannedTrees()
        }()
        
        // 3. Aguardando as Tasks acabarem
        let finalUser = try await userTask
        let finalPins = try await pinsTask
        let finalTrees = try await treesTask
        
        // 4. Busca a footprint (depende do User)
        let finalFootprint: Footprint? = try await {
            if let cachedFootprint: Footprint = cacheService.get(forKey: .userFootprint) {
                if cachedFootprint.userRecordID?.recordName == finalUser.recordID?.recordName {
                    return cachedFootprint
                }
            }
            return try await footprintService.fetchFootprint(for: finalUser)
        }()

        // 5. Monta o DTO
        let todayData = TodayDTO(currentUser: finalUser, allPins: finalPins, allTrees: finalTrees, userFootprint: finalFootprint)
        
        // 6. Atualiza os dados
        cacheService.set(finalUser, forKey: .currentUser)
        cacheService.set(finalPins, forKey: .allPins)
        cacheService.set(finalTrees, forKey: .allScannedTrees)
        
        if let footprintToCache = finalFootprint {
            cacheService.set(footprintToCache, forKey: .userFootprint)
        } else {
            cacheService.remove(forKey: .userFootprint)
        }
        
        return todayData
    }
}
