//
//  DistanceViewModelProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import Foundation
import UIKit

protocol DistanceViewModelProtocol: ObservableObject {
    var distanceText: String { get }
    var arService: ARServiceProtocol { get }
    var userDefaultService: UserDefaultServiceProtocol { get }
    
    var userHeight: Double { get }
    var measuredDiameter: Double { get }
    var treeImage: UIImage { get }
    var userLatitude: Double { get }
    var userLongitude: Double { get }
    var distance: Double { get }
    
    var showInfo: Bool { get set }
    var isMeasuring: Bool { get set }
    var shouldNavigate: Bool { get set }
    var showAddPointHint: Bool { get set }
    
    var treeSpecies: String { get set }
    
    func onAppear()
    func onDisappear()
    func getUserLocation(completion: @escaping () -> Void)
}
