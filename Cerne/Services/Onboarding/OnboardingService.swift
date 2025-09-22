//
//  OnboardingService.swift
//  Cerne
//
//  Created by Andrei Rech on 22/09/25.
//

import Foundation

class OnboardingService: OnboardingServiceProtocol {
    private let firstTimeKey = "firstTime"
    
    func isFirstTime() -> Bool {
        return UserDefaults.standard.bool(forKey: self.firstTimeKey) == false
    }
        
    func setFirstTimeDone() {
        UserDefaults.standard.set(true, forKey: self.firstTimeKey)
    }
}
