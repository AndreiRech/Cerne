//
//  UserServiceProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import SwiftData

protocol UserServiceProtocol {
    func fetchUsers() throws -> [User]
    func createUser(name: String, height: Double) throws
    func updateUser(user: User, newName: String?, newHeight: Double?) throws
    func fetchOrCreateCurrentUser(name: String?, height: Double?) async throws -> User
    func deleteUser(_ user: User) throws 
}
