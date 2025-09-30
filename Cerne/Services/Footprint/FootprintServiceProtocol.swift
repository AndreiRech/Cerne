//
//  FootprintServiceProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import SwiftData

protocol FootprintServiceProtocol {    
    func fetchFootprints() async throws -> [Footprint]
    func fetchFootprint(for user: User) async throws -> Footprint?
    func fetchResponses(for footprint: Footprint) async throws -> [Response]
    func createOrUpdateFootprint(for user: User, with responsesData: [ResponseData]) async throws -> Footprint
    func getQuestions(fileName: String) throws -> [Question]
}
