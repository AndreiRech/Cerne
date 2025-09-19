//
//  Response.swift
//  Cerne
//
//  Created by Andrei Rech on 05/09/25.
//

import Foundation
import SwiftData

@Model
final class Response: Identifiable {
    var id: UUID = UUID()
    var questionId: Int = 0
    var optionId: Int = 0
    var value: Double = 0.0
    
    var footprint: Footprint?
    
    init(id: UUID = UUID(), questionId: Int, optionId: Int, value: Double) {
        self.id = id
        self.questionId = questionId
        self.optionId = optionId
        self.value = value
    }
}
