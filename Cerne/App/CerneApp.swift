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
    @AppStorage("onboarding") var isOnboardingDone: Bool = false

    var body: some Scene {
        WindowGroup {
            if isOnboardingDone == false {
                OnboardingView(viewModel: OnboardingViewModel(userDefaultService: UserDefaultService(), userService: UserService()))
            } else {
                TabBar()
                    .environmentObject(appDelegate.quickActionService)
            }
        }
        .modelContainer(Persistence.shared.modelContainer)
    }
}
