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
    @Attribute(.unique) var id: UUID = UUID()
    var total: Double = 0.0
    
    init(id: UUID = UUID(), total: Double = 0.0) {
        self.id = id
        self.total = total
    }
}
