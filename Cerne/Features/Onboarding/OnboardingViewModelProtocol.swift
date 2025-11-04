//
//  OnboardingViewModelProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 25/09/25.
//

protocol OnboardingViewModelProtocol {
    var isCreatingUser: Bool { get set }
    var usernameError: Bool { get set }
    var heightError: Bool { get set }
    var heightErrorMessage: String { get set }
    
    var username: String { get set }
    var height: String { get set }
    var errorMessage: String? { get set }
    var currentPageIndex: Int? { get set }
    
    func validateAndSaveUser() async 
    func finishOnboarding()
}
