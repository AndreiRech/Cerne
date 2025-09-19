//
//  User.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import Foundation
import SwiftData

@Model
final class User: Identifiable {
    var id: UUID = UUID()
    var name: String = "Username"
    var height: Double = 1.65
    
    @Relationship(deleteRule: .cascade)
    var pins: [Pin] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Footprint.user)
    var footprint: Footprint?
    
    init(id: UUID = UUID(), name: String, height: Double) {
        self.id = id
        self.name = name
        self.height = height
    }
}
