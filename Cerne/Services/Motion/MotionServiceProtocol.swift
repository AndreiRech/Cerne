//
//  MotionServiceProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 09/09/25.
//

import Foundation
import Combine

protocol MotionServiceProtocol {
    var anglePublisher: Published<Double>.Publisher { get }
    
    func startUpdates()
    func stopUpdates()
}
