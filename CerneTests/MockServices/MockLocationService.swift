//
//  MockLocationService.swift
//  CerneTests
//
//  Created by Richard Fagundes Rodrigues on 12/09/25.
//

import Testing
import MapKit
@testable import Cerne

class MockLocationService: LocationServiceProtocol {
    var userLocation: UserLocation?
    var startCalled = false
    
    func start() {
        startCalled = true
    }
}
