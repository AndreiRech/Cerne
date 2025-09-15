//
//  DistanceViewModel.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import Foundation
import Combine

@Observable
class DistanceViewModel: DistanceViewModelProtocol {
    private var cancellables = Set<AnyCancellable>()
    var arService: ARServiceProtocol
    var distanceText: String = ""
    
    init(arService: ARServiceProtocol) {
        self.arService = arService
        subscribeToPublishers()
    }
    
    private func subscribeToPublishers() {
        arService.distancePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] distance in
                self?.distanceText = String(format: "Distância: %.2f m", distance)
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        arService.start()
    }
    
    func onDisappear() {
        arService.stop()
    }
}
