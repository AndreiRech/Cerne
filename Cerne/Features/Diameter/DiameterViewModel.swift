//
//  DiameterViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 09/09/25.
//

import SwiftUI
import Combine

@Observable
class DiameterViewModel: DiameterViewModelProtocol {
    var arService: ARServiceProtocol
    let userDefaultService: UserDefaultServiceProtocol
    
    var treeImage: UIImage
    var result: Double? = nil
    
    var showInfo: Bool = true
    var showAddPointHint: Bool = false
    var placePointTrigger: Bool = false
    var shouldNavigate: Bool = false
    var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var pointCount = 0
    
    init(treeImage: UIImage, userDefaultService: UserDefaultServiceProtocol) {
        self.userDefaultService = userDefaultService
        self.treeImage = treeImage
        self.arService = ARService.shared
        
        subscribeToPublishers()
        
        showInfo = userDefaultService.isFirstTime()
    }
    
    private func subscribeToPublishers() {
        arService.distancePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] distance in
                self?.result = Double(distance ?? 0)
                if distance != nil {
                    self?.pointCount = 0
                }
            }
            .store(in: &cancellables)
    }
    
    func placePointButtonTapped() {
        arService.addMeasurementPoint()
        pointCount += 1
        
        if pointCount == 2 {
            if let distance = result {
                print("Distance calculada: \(distance)")
            }
        }
    }
    
    func resetNodes() {
        arService.removeMeasurementPoints()
        result = nil
        pointCount = 0
    }
    
    func onAppear() {
        arService.interactionMode = .measuring
        
        resetNodes()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.arService.start(showOverlay: false)
        }
    }
    
    func onDisappear() {
        arService.stop()
    }
    
    deinit {
        cancellables.removeAll()
    }
}
