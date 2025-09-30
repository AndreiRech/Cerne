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
    private var onLocationReceived: (() -> Void)?
    
    var arService: ARServiceProtocol
    let userDefaultService: UserDefaultServiceProtocol
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
    
    var treeSpecies: String
    
    init(userDefaultService: UserDefaultServiceProtocol,
         userHeight: Double,
         measuredDiameter: Double,
         treeImage: UIImage,
         treeSpecies: String) {
        self.userHeight = userHeight
        self.measuredDiameter = measuredDiameter
        self.treeImage = treeImage
        self.userDefaultService = userDefaultService
        self.arService = ARService.shared
        self.treeSpecies = treeSpecies
        
        super.init()
        self.locationManager.delegate = self
        
        subscribeToPublishers()
        
        showInfo = userDefaultService.isFirstTime()
        if !showInfo {
            isMeasuring = true
        }
    }
    
    private func subscribeToPublishers() {
        arService.distancePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] distance in
                self?.distanceText = String(format: "%.2f longe da arvore", distance ?? 0)
                self?.distance = Double(distance ?? 0)
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        arService.interactionMode = .placingObjects
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.arService.start(showOverlay: false)
        }
    }
    
    func onDisappear() {
        arService.stop()
        locationManager.stopUpdatingLocation()
    }
    
    func getUserLocation(completion: @escaping () -> Void) {
        self.onLocationReceived = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.userLatitude = location.coordinate.latitude
            self.userLongitude = location.coordinate.longitude
            
            onLocationReceived?()
            onLocationReceived = nil
            locationManager.stopUpdatingLocation()
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao obter a localização: \(error.localizedDescription)")
    }
    
    deinit {
        cancellables.removeAll()
    }
}
