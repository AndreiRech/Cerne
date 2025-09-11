//
//  FootprintServiceProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import SwiftData

protocol FootprintServiceProtocol {
    func fetchFootprints() throws -> [Footprint]
    
    func createOrUpdateFootprint(for user: User, with newResponses: [Response]) throws
    
    func getQuestions(fileName: String) throws -> [Question]
}
