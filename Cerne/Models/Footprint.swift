//
//  Footprint.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import Foundation
import SwiftData

@Model
final class Footprint: Identifiable {
    var id: UUID = UUID()
    var total: Double = 0.0
    
    @Relationship(deleteRule: .cascade, inverse: \Response.footprint)
    var responses: [Response] = []
    
    var user: User?
    
    init(id: UUID = UUID(), total: Double = 0.0, responses: [Response] = []) {
        self.id = id
        self.total = total
        self.responses = responses
    }
}
