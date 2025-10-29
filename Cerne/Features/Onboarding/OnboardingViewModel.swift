//
//  OnboardingViewModel.swift
//  Cerne
//
//  Created by Andrei Rech on 25/09/25.
//

import Foundation
import SwiftUI // Importar SwiftUI para usar withAnimation

@Observable
class OnboardingViewModel: OnboardingViewModelProtocol {
    private var userDefaultService: UserDefaultServiceProtocol
    private var userService: UserServiceProtocol
    
    var isCreatingUser: Bool = false
    var usernameError: Bool = false
    var heightError: Bool = false
    var heightErrorMessage: String = ""
    var errorMessage: String?
    var currentPageIndex: Int? = 0
    
    var username: String = "" {
        didSet {
            if usernameError {
                withAnimation(.easeInOut(duration: 0.2)) {
                    usernameError = false
                }
            }
        }
    }
    
    var height: String = "" {
        didSet {
            if heightError {
                withAnimation(.easeInOut(duration: 0.2)) {
                    heightError = false
                }
            }
        }
    }
    
    let onboardingPages: [OnboardingPage] = [
        OnboardingPage(image: .onboarding1, title: String(localized: "Descubra o quanto de carbono cada árvore pode capturar"), description: String(localized: "Use realidade aumentada para identificar a espécies das árvores e calcular a capacidade de sequestro de CO₂")),
        OnboardingPage(image: .onboarding2, title: String(localized: "Acompanhe a floresta crescendo bem pertinho de você"), description: String(localized: "Seus registros fortalecem um banco de dados vivo que revela a biodiversidade e o carbono capturado em todo o mundo")),
        OnboardingPage(image: .onboarding3, title: String(localized: "Faça parte da comunidade"), description: String(localized: "Some seu impacto ao de milhares de pessoas que ajudam a neutralizar CO₂"))
    ]
    
    init(userDefaultService: UserDefaultServiceProtocol, userService: UserServiceProtocol) {
        self.userDefaultService = userDefaultService
        self.userService = userService
    }
    
    func finishOnboarding() {
        isCreatingUser = true
    }
    
    @MainActor
    func validateAndSaveUser() async {
        let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
        let trimmedHeight = height.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".")
        
        var hasError = false
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if trimmedUsername.isEmpty {
                usernameError = true
                hasError = true
            } else {
                usernameError = false
            }
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if trimmedHeight.isEmpty {
                heightErrorMessage = "Altura não pode estar vazia."
                heightError = true
                hasError = true
            } else if let value = Double(trimmedHeight), value > 1.0 {
                heightError = false
            } else {
                heightErrorMessage = "Altura inválida. Deve ser maior que 1,0 metro."
                heightError = true
                hasError = true
            }
        }
        
        guard !hasError else {
            return
        }
        
        await saveUser()
    }
    
    private func saveUser() async {
        let doubleHeight = Double(height.replacingOccurrences(of: ",", with: ".")) ?? 1.65
        
        do {
            let _ = try await userService.fetchOrCreateCurrentUser(name: username, height: doubleHeight)
            userDefaultService.setOnboarding(value: true)
            self.errorMessage = nil
        } catch let error as UserValidationError {
            self.errorMessage = error.errorDescription ?? "Ocorreu um erro de validação."
        } catch {
            self.errorMessage = "Ocorreu um erro inesperado. Tente novamente."
        }
    }
}
