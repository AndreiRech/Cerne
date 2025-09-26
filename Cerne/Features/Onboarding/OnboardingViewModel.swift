//
//  OnboardingViewModel.swift
//  Cerne
//
//  Created by Andrei Rech on 25/09/25.
//

import Foundation

@Observable
class OnboardingViewModel: OnboardingViewModelProtocol {
    private var userDefaultService: UserDefaultServiceProtocol
    private var userService: UserServiceProtocol
    
    var isCreatingUser: Bool = false
    var username: String = ""
    var height: String = ""
    var errorMessage: String?
    var currentPageIndex: Int? = 0
    
    let onboardingPages: [OnboardingPage] = [
        OnboardingPage(image: .onboarding1, title: "Descubra quanto carbono cada árvore pode capturar", description: "Use realidade aumentada para identificar a espécies das árvores e calcular o capacidade de sequestro de CO₂"),
        OnboardingPage(image: .onboarding2, title: "Acompanhe a floresta crescendo bem pertinho de você", description: "Seus registros fortalecem um banco de dados vivo que revela a biodiversidade e o carbono capturado em todo o mundo"),
        OnboardingPage(image: .onboarding3, title: "Faça parte da comunidade", description: "Some seu impacto ao de milhares de pessoas que ajudam a neutralizar CO₂")
    ]
    
    init(userDefaultService: UserDefaultServiceProtocol, userService: UserServiceProtocol) {
        self.userDefaultService = userDefaultService
        self.userService = userService
    }
    
    func finishOnboarding() {
        isCreatingUser = true
    }
    
    func saveUser() async {
        let doubleHeight = Double(height) ?? 1.65
        
        do {
            let _ = try await userService.fetchOrCreateCurrentUser(name: username, height: doubleHeight)
            userDefaultService.setOnboarding(value: true)
        } catch let error as UserValidationError {
            errorMessage = error.errorDescription ?? "Ocorreu um erro de validação."
        } catch {
            errorMessage = "Ocorreu um erro inesperado. Tente novamente."
        }
    }
}

