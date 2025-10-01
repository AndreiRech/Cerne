//
//  MockUserService.swift
//  CerneTests
//
//  Created by Gabriel Kowaleski on 09/09/25.
//

@testable import Cerne
import Foundation
import CloudKit

class MockUserService: UserServiceProtocol {
    var users: [User]
    var shouldFail: Bool
    
    init(shouldFail: Bool = false, initialUsers: [User] = []) {
        self.shouldFail = shouldFail
        self.users = initialUsers
        
        if self.users.isEmpty {
            let recordID = CKRecord.ID(recordName: UUID().uuidString)
            self.users.append(User(id: recordID.recordName, name: "Default User", height: 1.75))
        }
    }
    
    func fetchUsers() async throws -> [User] {
        if shouldFail {
            throw GenericError.serviceError
        }
        return users
    }
    
    func fetchOrCreateCurrentUser(name: String?, height: Double?) async throws -> User {
        if shouldFail {
            throw GenericError.serviceError
        }

        if let existingUser = users.first {
            return existingUser
        }

        guard let name = name, let height = height else {
            throw GenericError.serviceError
        }
        guard name.count >= 3 else {
            throw UserValidationError.nameTooShort
        }
        guard (1.0...3.0).contains(height) else {
            throw UserValidationError.invalidHeight
        }
        
        let recordID = CKRecord.ID(recordName: UUID().uuidString)
        let newUser = User(id: recordID.recordName, name: name, height: height)
        self.users.append(newUser)
        return newUser
    }

    func fetchUser(by recordID: CKRecord.ID) async throws -> User? {
        if shouldFail {
            throw GenericError.serviceError
        }
        return users.first { $0.recordID == recordID }
    }

    func updateUser(user: User) async throws -> User {
        if shouldFail {
            throw GenericError.serviceError
        }

        guard user.name.count >= 3 else {
            throw UserValidationError.nameTooShort
        }
        guard (1.0...3.0).contains(user.height) else {
            throw UserValidationError.invalidHeight
        }
        
        if let index = users.firstIndex(where: { $0.recordID == user.recordID }) {
            users[index] = user
            return user
        }
        
        throw CKError(.unknownItem)
    }

    func deleteUser(_ user: User) async throws {
        if shouldFail {
            throw GenericError.serviceError
        }
        
        if let index = users.firstIndex(where: { $0.recordID == user.recordID }) {
            users.remove(at: index)
        } else {
            throw CKError(.unknownItem)
        }
    }
}
