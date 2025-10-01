//
//  MockProfileRepository.swift
//  CerneTests
//
//  Created by Andrei Rech on 01/10/25.
//

import Foundation
@testable import Cerne

class MockProfileRepository: ProfileRepositoryProtocol {

    var shouldFail: Bool
    var profileData: ProfileDTO?
    
    var deleteAccountCalled = false
    
    init(shouldFail: Bool = false, profileData: ProfileDTO? = nil) {
        self.shouldFail = shouldFail
        self.profileData = profileData
    }
    
    func fetchProfileData() async throws -> ProfileDTO {
        if shouldFail {
            throw GenericError.serviceError
        }
        guard let data = profileData else {
            throw GenericError.serviceError
        }
        return data
    }
    
    func deleteAccount(for user: User) async throws {
        deleteAccountCalled = true
    }
}
