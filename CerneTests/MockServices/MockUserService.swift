//
//  MockUserService.swift
//  CerneTests
//
//  Created by Gabriel Kowaleski on 09/09/25.
//

@testable import Cerne
import Foundation
import SwiftData

class MockUserService: UserServiceProtocol {
    var users: [User] = []
    var shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func createUser(name: String, height: Double) throws {
        if shouldFail {
            throw NSError(domain: "MockUserService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create user."])
        }
        
        let newUser = User(name: name, height: height)
        users.append(newUser)
    }
    
    func updateUser(user: User, newName: String?, newHeight: Double?) throws {
        if shouldFail {
            throw NSError(domain: "MockUserService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to update user."])
        }
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index].name = newName ?? users[index].name
            users[index].height = newHeight ?? users[index].height
        }
    }
}
