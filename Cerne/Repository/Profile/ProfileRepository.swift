//
//  ProfileRepository.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

class ProfileRepository: ProfileRepositoryProtocol {
    private let pinService: PinServiceProtocol
    private let userService: UserServiceProtocol
    private let treeService: ScannedTreeServiceProtocol
    private let footprintService: FootprintServiceProtocol
    private let userDefaultService: UserDefaultServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    init(pinService: PinServiceProtocol,
         userService: UserServiceProtocol,
         treeService: ScannedTreeServiceProtocol,
         footprintService: FootprintServiceProtocol,
         userDefaultService: UserDefaultServiceProtocol,
         cacheService: CacheServiceProtocol = CacheService.shared) {
        self.pinService = pinService
        self.userService = userService
        self.treeService = treeService
        self.footprintService = footprintService
        self.userDefaultService = userDefaultService
        self.cacheService = cacheService
    }
    
    func fetchProfileData() async throws -> ProfileDTO {
        // 1. Realizando busca individual na cache
        let cachedUser: User? = cacheService.get(forKey: .currentUser)
        let cachedPins: [Pin]? = cacheService.get(forKey: .allPins)
        let cachedTrees: [ScannedTree]? = cacheService.get(forKey: .allScannedTrees)
        
        // 2. Realizando a chamada no banco para quem não estiver disponível
        async let userTask: User = {
            if let cachedUser {
                return cachedUser
            }
            print("Realizando requisição ao banco de dados para User")
            return try await userService.fetchOrCreateCurrentUser(name: nil, height: nil)
        }()
        
        async let pinsTask: [Pin] = {
            if let cachedPins {
                return cachedPins
            }
            print("Realizando requisição ao banco de dados para Pins")
            return try await pinService.fetchPins()
        }()
        
        async let treesTask: [ScannedTree] = {
            if let cachedTrees {
                return cachedTrees
            }
            print("Realizando requisição ao banco de dados para Arvores")
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
            print("Realizando requisição ao banco de dados para Footprint")
            return try await footprintService.fetchFootprint(for: finalUser)
        }()
        
        // 5. Monta o DTO
        let profileData = ProfileDTO(currentUser: finalUser, allPins: finalPins, allTrees: finalTrees, userFootprint: finalFootprint)
        
        // 6. Atualiza os dados
        cacheService.set(finalUser, forKey: .currentUser)
        cacheService.set(finalPins, forKey: .allPins)
        cacheService.set(finalTrees, forKey: .allScannedTrees)
        
        if let footprintToCache = finalFootprint {
            cacheService.set(footprintToCache, forKey: .userFootprint)
        } else {
            cacheService.remove(forKey: .userFootprint)
        }
        
        return profileData
    }
    
    func deleteAccount(for user: User) async throws {
        guard let userRecordID = user.recordID else { return }
        
        async let allPinsTask = pinService.fetchPins()
        async let userFootprintTask = footprintService.fetchFootprint(for: user)
        
        let allPins = try await allPinsTask
        let userFootprint = try await userFootprintTask
        
        let userPins = allPins.filter { $0.userRecordID?.recordName == userRecordID.recordName }
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            if let footprintToDelete = userFootprint {
                group.addTask {
                    try await self.footprintService.deleteFootprint(footprintToDelete)
                }
            }
            
            for pin in userPins {
                group.addTask {
                    try await self.pinService.deletePin(pin)
                }
            }
            
            try await group.waitForAll()
        }
        
        try await userService.deleteUser(user)
        
        clearUserCache()
        userDefaultService.setOnboarding(value: false)
        userDefaultService.setFirstTime(value: false)
    }
    
    private func clearUserCache() {
        cacheService.remove(forKey: .currentUser)
        cacheService.remove(forKey: .allPins)
        cacheService.remove(forKey: .allScannedTrees)
        cacheService.remove(forKey: .userFootprint)
        cacheService.remove(forKey: .responses)
    }
}
