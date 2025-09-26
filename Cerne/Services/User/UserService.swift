//
//  UserService.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import SwiftData
import CloudKit

class UserService: UserServiceProtocol {
    private var modelContext: ModelContext
    
    @MainActor
    init() {
        self.modelContext = Persistence.shared.modelContext
    }
    
    func fetchUsers() throws -> [User] {
        let descriptor = FetchDescriptor<User>()
        
        do {
            let pins = try modelContext.fetch(descriptor)
            return pins
        } catch {
            throw GenericError.serviceError
        }
    }
    
    func fetchOrCreateCurrentUser(name: String? = nil, height: Double? = nil) async throws -> User {
        let container = CKContainer.default()
        
        let userRecordID = try await container.userRecordID()
        let userID = userRecordID.recordName
        
        var descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.id == userID }
        )
        descriptor.fetchLimit = 1
                
        if let existingUser = try modelContext.fetch(descriptor).first {
            return existingUser
        } else {
            if let name, let height {
                guard (1.0...3.0).contains(height) else {
                    throw UserValidationError.invalidHeight
                }
                
                guard name.count >= 4 else {
                    throw UserValidationError.nameTooShort
                }
                
                
                let newUser = User(id: userID, name: name, height: height)
                modelContext.insert(newUser)
                try save()
                
                return newUser
            } else {
                throw GenericError.serviceError
            }
        }
    }
    
    func createUser(name: String, height: Double) throws {
        let newUser = User(name: name, height: height)
        modelContext.insert(newUser)
        try save()
    }
    
    func updateUser(user: User, newName: String?, newHeight: Double?) throws {
        user.name = newName ?? user.name
        user.height = newHeight ?? user.height
        try save()
    }
    
    private func save() throws{
        try modelContext.save()
    }
}
