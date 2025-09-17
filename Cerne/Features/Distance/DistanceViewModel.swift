//
//  DistanceViewModel.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import Foundation
import Combine
import UIKit
import CoreLocation

@Observable
class DistanceViewModel: NSObject, DistanceViewModelProtocol, CLLocationManagerDelegate {
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()
    
    var arService: ARServiceProtocol
    var distanceText: String = ""
    
    let userHeight: Double
    let measuredDiameter: Double
    var treeImage: UIImage
    var userLatitude: Double = 0.0
    var userLongitude: Double = 0.0
    var distance: Double = 0.0
    
    var showInfo: Bool = true
    var isMeasuring: Bool = false
    var shouldNavigate: Bool = false
    var showAddPointHint: Bool = false
    
    init(arService: ARServiceProtocol,
         userHeight: Double,
         measuredDiameter: Double,
         treeImage: UIImage) {
        self.arService = arService
        self.userHeight = userHeight
        self.measuredDiameter = measuredDiameter
        self.treeImage = treeImage
        
        super.init()
        self.locationManager.delegate = self
        
        subscribeToPublishers()
    }
    
    private func subscribeToPublishers() {
        arService.distancePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] distance in
                self?.distanceText = String(format: "%.2f longe da arvore", distance)
                self?.distance = Double(distance)
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        arService.start(showOverlay: false)
    }
    
    func onDisappear() {
        arService.stop()
    }
    
    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.userLatitude = location.coordinate.latitude
            self.userLongitude = location.coordinate.longitude
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao obter a localização: \(error.localizedDescription)")
    }
}
