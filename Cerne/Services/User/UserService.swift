//
//  UserService.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import SwiftData

class UserService: UserServiceProtocol {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
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
