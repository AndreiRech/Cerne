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
    @State private var isSplashScreenActive = true

    var body: some Scene {
        WindowGroup {
            if isSplashScreenActive {
                SplashScreenView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.isSplashScreenActive = false
                            }
                        }
                    }
            } else {
                if isOnboardingDone == false {
                    OnboardingView(viewModel: OnboardingViewModel(userDefaultService: UserDefaultService(), userService: UserService()))
                } else {
                    TabBar()
                        .environmentObject(appDelegate.quickActionService)
                }
            }
        }
    }
}
