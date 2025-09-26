//
//  UserDefaultServiceProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 22/09/25.
//

protocol UserDefaultServiceProtocol {
    func setOnboardingDone()
    func isOnboardingDone() -> Bool
    func isFirstTime() -> Bool
    func setFirstTimeDone()
    func setPinReported(pin: Pin)
    func isPinReported(pin: Pin) -> Bool
}
