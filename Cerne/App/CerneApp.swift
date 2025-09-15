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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            TabBar()
                .environmentObject(appDelegate.quickActionService)
        }
        .modelContainer(Persistence.shared.modelContainer)
    }
}
