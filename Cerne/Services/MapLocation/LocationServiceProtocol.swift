//
//  LocationServiceProtocol.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import Foundation
import Combine

protocol LocationServiceProtocol {
    
    var userLocationPublisher: Published<UserLocation?>.Publisher { get }
    
    func requestLocationAuthorization()
}
