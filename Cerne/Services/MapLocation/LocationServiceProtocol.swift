//
//  LocationServiceProtocol.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import Observation
import Foundation
import Combine

protocol LocationServiceProtocol: Observable {
    var userLocation: UserLocation? { get set }
    var userLocationPublisher: AnyPublisher<UserLocation, Never> { get }
    func start()
}
