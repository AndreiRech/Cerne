//
//  DIstanceViewModelProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import Foundation
import Combine

protocol DistanceViewModelProtocol: ObservableObject {
    var distanceText: String { get }
    var arService: ARServiceProtocol { get }
    
    func onAppear()
    func onDisappear()
}
