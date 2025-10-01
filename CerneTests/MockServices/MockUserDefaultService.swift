//
//  MockLocationService.swift
//  CerneTests
//
//  Created by Richard Fagundes Rodrigues on 12/09/25.
//

import Testing
@testable import Cerne
import Combine

class MockUserDefaultService: UserDefaultServiceProtocol {
    var isFirst: Bool
    var isOnboardingDoneVar: Bool
    var pins: [Pin] = []
    
    init(isFirst: Bool = true, isOnboardingDoneVar: Bool = false) {
        self.isFirst = isFirst
        self.isOnboardingDoneVar = isOnboardingDoneVar
    }
    
    func isFirstTime() -> Bool {
        isFirst
    }
    
    func setFirstTime(value: Bool = false) {
        isFirst = value
    }
    
    func setOnboarding(value: Bool = false) {
        isOnboardingDoneVar = value
    }
    
    func isOnboardingDone() -> Bool {
        isOnboardingDoneVar
    }
    
    func setPinReported(pin: Pin) {
        pins.append(pin)
    }
    
    func isPinReported(pin: Pin) -> Bool {
        if pins.contains(where: { $0.id == pin.id }) {
            return true
        }
        return false
    }
}
