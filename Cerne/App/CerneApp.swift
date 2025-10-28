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
                        if isOnboardingDone == false {
                            OnboardingView(viewModel: OnboardingViewModel(userDefaultService: UserDefaultService(), userService: userService))
                        } else {
                            OnboardingView(viewModel: OnboardingViewModel(userDefaultService: UserDefaultService(), userService: userService))
                        }
                    case .error:
                        OnboardingView(viewModel: OnboardingViewModel(userDefaultService: UserDefaultService(), userService: userService))
                    }
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
