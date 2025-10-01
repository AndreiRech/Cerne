//
//  MockTodayRepository.swift
//  CerneTests
//
//  Created by Andrei Rech on 01/10/25.
//

import Foundation
@testable import Cerne

class MockTodayRepository: TodayRepositoryProtocol {
    var mockTodayDTO: TodayDTO?
    var shouldFail = false
    var fetchTodayDataCallCount = 0

    func fetchTodayData() async throws -> TodayDTO {
        fetchTodayDataCallCount += 1
        
        if shouldFail {
            throw GenericError.serviceError
        }
        
        if let dto = mockTodayDTO {
            return dto
        }
        
        throw GenericError.serviceError
    }
}
