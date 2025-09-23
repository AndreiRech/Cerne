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
    var pins: [Pin] = []
    
    init(isFirst: Bool = true) {
        self.isFirst = isFirst
    }
    
    func isFirstTime() -> Bool {
        isFirst
    }
    
    func setFirstTimeDone() {
        isFirst = false
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
