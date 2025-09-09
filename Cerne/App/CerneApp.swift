//
//  CerneApp.swift
//  Cerne
//
//  Created by Andrei Rech on 03/09/25.
//

import SwiftUI
import SwiftData

@main
struct CerneApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            ScannedTree.self,
            Pin.self,
            Footprint.self,
            Response.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, cloudKitDatabase: .automatic)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabBar()
        }
        .modelContainer(sharedModelContainer)
    }
}
