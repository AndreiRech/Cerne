//
//  MockLocationService.swift
//  CerneTests
//
//  Created by Richard Fagundes Rodrigues on 12/09/25.
//

import Testing
@testable import Cerne
import Combine

class MockOnboardingService: OnboardingServiceProtocol {
    var isFirst: Bool
    
    init(isFirst: Bool = true) {
        self.isFirst = isFirst
    }
    
    func isFirstTime() -> Bool {
        isFirst
    }
    
    func setFirstTimeDone() {
        isFirst = false
    }
}
