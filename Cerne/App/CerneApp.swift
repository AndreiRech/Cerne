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
    var body: some Scene {
        WindowGroup {
            TabBar()
        }
        .modelContainer(for: [User.self, ScannedTree.self, Pin.self, Footprint.self])
    }
}
