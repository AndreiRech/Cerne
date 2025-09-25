//
//  UserDefaultService.swift
//  Cerne
//
//  Created by Andrei Rech on 22/09/25.
//

import Foundation

class UserDefaultService: UserDefaultServiceProtocol {
    private let onboardingKey = "onboarding"
    private let firstTimeKey = "firstTime"
    private let reportsKey = "reports"
    
    func isOnboardingDone() -> Bool {
        return UserDefaults.standard.bool(forKey: self.onboardingKey) == false
    }
    
    func setOnboardingDone() {
        UserDefaults.standard.set(true, forKey: self.onboardingKey)
    }
    
    func isFirstTime() -> Bool {
        return UserDefaults.standard.bool(forKey: self.firstTimeKey) == false
    }
    
    func setFirstTimeDone() {
        UserDefaults.standard.set(true, forKey: self.firstTimeKey)
    }
    
    func setPinReported(pin: Pin) {
        var reportedPins = UserDefaults.standard.array(forKey: reportsKey) as? [String] ?? []
        let idString = pin.id.uuidString
        
        if !reportedPins.contains(idString) {
            reportedPins.append(idString)
            UserDefaults.standard.set(reportedPins, forKey: reportsKey)
        }
    }
    
    func isPinReported(pin: Pin) -> Bool {
        let reportedPins = UserDefaults.standard.array(forKey: reportsKey) as? [String] ?? []
        return reportedPins.contains(pin.id.uuidString)
    }
}
