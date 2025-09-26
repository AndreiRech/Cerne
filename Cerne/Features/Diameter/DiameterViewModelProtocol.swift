//
//  DiameterViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 09/09/25.
//

import SwiftUI

protocol DiameterViewModelProtocol: ObservableObject {
    var arService: ARServiceProtocol { get }
    var userDefaultService: UserDefaultServiceProtocol { get }
    
    var treeImage: UIImage { get }
    var result: Double? { get set }
    var showInfo: Bool { get set }
    var showAddPointHint: Bool { get set }
    var placePointTrigger: Bool { get set }
    var shouldNavigate: Bool { get set }
    var errorMessage: String? { get set }
    
    func placePointButtonTapped()
    func onAppear()
    func onDisappear()
    func resetNodes()
}
