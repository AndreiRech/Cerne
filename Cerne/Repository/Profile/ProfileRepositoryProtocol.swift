//
//  ProfileRepositoryProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//


import Foundation

protocol ProfileRepositoryProtocol {
    func fetchProfileData() async throws -> ProfileDTO
    func deleteAccount(for user: User) async throws
}
