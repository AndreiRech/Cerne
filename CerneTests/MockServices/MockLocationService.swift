//
//  MockLocationService.swift
//  CerneTests
//
//  Created by Richard Fagundes Rodrigues on 12/09/25.
//

import Testing
import MapKit
@testable import Cerne
import Combine

class MockLocationService: LocationServiceProtocol {
    var userLocationPublisher: AnyPublisher<UserLocation, Never>
    
    var userLocation: UserLocation?
    var startCalled = false
    
    init() {
        userLocationPublisher = PassthroughSubject<UserLocation, Never>().eraseToAnyPublisher()
    }
    
    func start() {
        startCalled = true
    }
}
