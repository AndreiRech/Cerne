//
//  LocationServiceProtocol.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import Observation

protocol LocationServiceProtocol: Observable {
    var userLocation: UserLocation? { get set }
}
