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
    @State private var userCheckStatus: UserCheckStatus = .checking
    private let userService = UserService()
    private let userDefaultService = UserDefaultService()
        
    var body: some Scene {
        WindowGroup {
            if isSplashScreenActive {
                SplashScreenView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.isSplashScreenActive = false
                            }
                        }
                    }
            } else {
                Group {
                    switch userCheckStatus {
                    case .checking:
                        ProgressView()
                            .onAppear {
                                Task {
                                    await checkUserStatus()
                                }
                            }
                    case .existingUser:
                        TabBar()
                            .environmentObject(appDelegate.quickActionService)
                    case .newUser:
                        if !isOnboardingDone {
                            OnboardingView(
                                viewModel: OnboardingViewModel(
                                    userDefaultService: UserDefaultService(),
                                    userService: userService
                                ),
                                isOnbDone: $isOnboardingDone
                            )
                        } else {
                            TabBar()
                                .environmentObject(appDelegate.quickActionService)
                        }
                    case .error:
                        if isOnboardingDone {
                            TabBar()
                                .environmentObject(appDelegate.quickActionService)
                        } else {
                            OnboardingView(
                                viewModel: OnboardingViewModel(
                                    userDefaultService: UserDefaultService(),
                                    userService: userService
                                ),
                                isOnbDone: $isOnboardingDone
                            )
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .didDeleteAccount)) { _ in
                    self.isOnboardingDone = false
                    self.userCheckStatus = .newUser
                }
            }
        }
    }
    
    private func checkUserStatus() async {
        do {
            if let _ = try await userService.fetchCurrentUserIfExists() {
                if !isOnboardingDone {
                    isOnboardingDone = true
                }
                userCheckStatus = .existingUser
            } else {
                userCheckStatus = .newUser
            }
        } catch let error as UserError where error == .iCloudAccountNotFound {
            print("Verificação falhou: usuário não logado no iCloud.")
            userCheckStatus = .error
        }
        catch {
            print("Erro ao verificar usuário existente: \(error)")
            userCheckStatus = .error
        }
    }
}
