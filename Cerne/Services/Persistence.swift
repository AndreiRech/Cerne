//
//  Persistence.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 12/09/25.
//

import SwiftData
import Foundation

@MainActor
final class Persistence {
    static let shared = Persistence()
    
    let modelContainer: ModelContainer
    var modelContext: ModelContext {
        modelContainer.mainContext
    }
    
    init() {
        let schema = Schema([
            User.self,
            ScannedTree.self,
            Pin.self,
            Footprint.self,
            Response.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, cloudKitDatabase: .automatic)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
