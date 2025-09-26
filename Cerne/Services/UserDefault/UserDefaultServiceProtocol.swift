//
//  UserDefaultServiceProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 22/09/25.
//

protocol UserDefaultServiceProtocol {
    func setOnboarding(value: Bool)
    func isOnboardingDone() -> Bool
    func isFirstTime() -> Bool
    func setFirstTime(value: Bool)
    func setPinReported(pin: Pin)
    func isPinReported(pin: Pin) -> Bool
}
