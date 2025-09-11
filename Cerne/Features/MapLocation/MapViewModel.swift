//
//  MapViewModel.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 08/09/25.
//

import MapKit
import Combine
import SwiftUI

@Observable
final class MapViewModel: MapViewModelProtocol {
    
    var position: MapCameraPosition = .automatic
    var userLocation: UserLocation?
    var pins: [Pin] = []
    var selectedPin: Pin?
    
    private var userService: UserServiceProtocol
    var pinService: PinServiceProtocol
    private var scannedTreeService: ScannedTreeServiceProtocol
    private var locationService: LocationServiceProtocol
    
    
    init(locationService: LocationServiceProtocol,
         pinService: PinServiceProtocol,
         userService: UserServiceProtocol,
         scannedTreeService: ScannedTreeServiceProtocol) {
        self.locationService = locationService
        self.pinService = pinService
        self.userService = userService
        self.scannedTreeService = scannedTreeService
    }
    
    func refreshLocation() {
        userLocation = locationService.userLocation
        updatePositionIfNeeded()
    }
    
    private func updatePositionIfNeeded() {
        guard let location = userLocation else { return }
        position = .region(
            MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
    
    func getPins() {
        do {
            try             pins = pinService.fetchPins()
            
        } catch {
            print("erro")
        }
    }
    
    func addPin(image: Data?, species: String, height: Double, dap: Double) {
        guard let userLocation = userLocation else { return }
        
        do {
            let newTree = try scannedTreeService.createScannedTree(species: species, height: height, dap: dap, totalCO2: 0)
            
            // TODO: Substituir pela lógica de usuário logado
            let currentUser = User(name: "Username", height: 1.65)
            try userService.createUser(name: currentUser.name, height: currentUser.height)
            
            try pinService.createPin(
                image: image,
                latitude: userLocation.latitude,
                longitude: userLocation.longitude,
                user: currentUser,
                tree: newTree
            )
                        
            getPins()
            
        } catch {
            print("Erro ao salvar o Pin: \(error.localizedDescription)")
        }
    }
}
