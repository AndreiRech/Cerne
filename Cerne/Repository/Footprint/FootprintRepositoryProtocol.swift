//
//  FootprintRepositoryProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation

protocol FootprintRepositoryProtocol {
    func fetchFootprintData() async throws -> FootprintDTO
    func saveFootprint(for user: User, with responses: [ResponseData]) async throws -> Footprint
    func getQuestions() throws -> [Question]
}
