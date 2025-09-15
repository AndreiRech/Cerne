//
//  MapViewModelTests.swift
//  CerneTests
//
//  Created by Richard Fagundes Rodrigues on 12/09/25.
//

import SwiftUI
import Testing
import MapKit
@testable import Cerne

struct MapViewModelTests {
    
    @Test func testOnMapAppearStartsServicesAndFetchesPins() async throws {
        let locationService = MockLocationService()
        let pinService = MockPinService()
        let userService = MockUserService()
        let treeService = MockScannedTreeService()
        
        pinService.pins = [
            Pin(image: Data(), latitude: 1.0, longitude: 1.0, date: Date(), user: User(name: "User1", height: 1.70), tree: ScannedTree(species: "A", height: 10.0, dap: 1, totalCO2: 1)),
            Pin(image: Data(), latitude: 10.0, longitude: 10.0, date: Date(), user: User(name: "User2", height: 1.64), tree: ScannedTree(species: "b", height: 8.32, dap: 2, totalCO2: 2))
        ]
        
        let viewModel = MapViewModel(locationService: locationService,
                               pinService: pinService,
                               userService: userService,
                               scannedTreeService: treeService)

        viewModel.onMapAppear()

        #expect(locationService.startCalled == true)
        
        #expect(viewModel.pins.isEmpty == false)
    }
    
    @Test func testRefreshLocation() async throws {
        let locationService = MockLocationService()
        let pinService = MockPinService()
        let userService = MockUserService()
        let treeService = MockScannedTreeService()
        let mockLocation = UserLocation(latitude: -23.5, longitude: -46.6)
        
        locationService.userLocation = mockLocation
        
        let viewModel = MapViewModel(locationService: locationService,
                               pinService: pinService,
                               userService: userService,
                               scannedTreeService: treeService)
        
        viewModel.refreshLocation()
        
        #expect(viewModel.userLocation != nil)
        #expect(viewModel.userLocation?.latitude == mockLocation.latitude)
        #expect(viewModel.userLocation?.longitude == mockLocation.longitude)
    }
    
    @Test func testGetPins() async throws {
        let locationService = MockLocationService()
        let pinService = MockPinService()
        let userService = MockUserService()
        let treeService = MockScannedTreeService()
        
        pinService.pins = [
            Pin(image: Data(), latitude: 1.0, longitude: 1.0, date: Date(), user: User(name: "User1", height: 1.70), tree: ScannedTree(species: "A", height: 10.0, dap: 1, totalCO2: 1)),
            Pin(image: Data(), latitude: 10.0, longitude: 10.0, date: Date(), user: User(name: "User2", height: 1.64), tree: ScannedTree(species: "b", height: 8.32, dap: 2, totalCO2: 2))
        ]

        let viewModel = MapViewModel(locationService: locationService,
                               pinService: pinService,
                               userService: userService,
                               scannedTreeService: treeService)
        
        viewModel.getPins()
        
        #expect(viewModel.pins.count > 0)
        #expect(viewModel.pins.first?.tree.species == "A")
    }
    
    @Test func testGetPinsFailure() async throws {
        let locationService = MockLocationService()
        let pinService = MockPinService(shouldFail: true)
        let userService = MockUserService()
        let treeService = MockScannedTreeService()

        let viewModel = MapViewModel(locationService: locationService,
                               pinService: pinService,
                               userService: userService,
                               scannedTreeService: treeService)
        
        viewModel.getPins()
        
        #expect(viewModel.pins.isEmpty)
    }
    
}
