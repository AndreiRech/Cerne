//
//  FootprintService.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import SwiftData

class FootprintService: FootprintServiceProtocol {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func createOrUpdateFootprint(for user: User, with newResponses: [Response]) throws {
        let newTotal = newResponses.reduce(0) { $0 + $1.value }
        
        if let existingFootprint = user.footprint {
            existingFootprint.responses.forEach { oldResponse in
                modelContext.delete(oldResponse)
            }
            
            newResponses.forEach { newResponse in
                modelContext.insert(newResponse)
            }
            
            existingFootprint.responses = newResponses
            existingFootprint.total = newTotal
            
        } else {
            newResponses.forEach { newResponse in
                modelContext.insert(newResponse)
            }
            
            let newFootprint = Footprint(total: newTotal, responses: newResponses)
            
            user.footprint = newFootprint
        }
    }
}
