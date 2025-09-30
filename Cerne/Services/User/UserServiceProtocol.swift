//
//  UserServiceProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
    func fetchOrCreateCurrentUser(name: String?, height: Double?) async throws -> User
    func updateUser(user: User) async throws -> User
    func deleteUser(_ user: User) async throws
}
