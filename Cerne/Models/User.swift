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
    var id: String?
    var name: String = "Username"
    var height: Double = 1.65
    
    @Relationship(deleteRule: .cascade)
    var pins: [Pin]?
    
    @Relationship(deleteRule: .cascade, inverse: \Footprint.user)
    var footprint: Footprint?
    
    init(id: String? = nil, name: String, height: Double, pins: [Pin]? = [], footprint: Footprint? = nil) {
        self.id = id
        self.name = name
        self.height = height
        self.pins = pins
        self.footprint = footprint
    }
}
