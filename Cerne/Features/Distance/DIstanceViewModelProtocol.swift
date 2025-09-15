//
//  DIstanceViewModelProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import Foundation
import Combine
import UIKit

protocol DistanceViewModelProtocol: ObservableObject {
    var distanceText: String { get }
    var arService: ARServiceProtocol { get }
    var shouldNavigate: Bool { get set }
    
    var userHeight: Double { get }
    var measuredDiameter: Double { get }
    var treeImage: UIImage { get }
    var userLatitude: Double { get }
    var userLongitude: Double { get }
    var distance: Double { get }
    
    func onAppear()
    func onDisappear()
    func getUserLocation()
}
