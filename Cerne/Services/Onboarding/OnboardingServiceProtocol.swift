//
//  OnboardingServiceProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 22/09/25.
//

protocol OnboardingServiceProtocol {
    func isFirstTime() -> Bool
    
    func setFirstTimeDone()
}
