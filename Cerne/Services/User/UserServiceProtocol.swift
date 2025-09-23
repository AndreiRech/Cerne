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
    func fetchOrCreateCurrentUser() async throws -> User
}
