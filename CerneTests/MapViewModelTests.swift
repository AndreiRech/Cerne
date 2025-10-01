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
import CloudKit

struct MapViewModelTests {
    
    @Test func testOnMapAppearStartsServicesAndFetchesPins() async throws {
        let locationService = MockLocationService()
        let pinService = MockPinService()
        let userService = MockUserService()
        let treeService = MockScannedTreeService()
        
        pinService.pins = [
            Pin(image: UIImage(), latitude: 1.0, longitude: 1.0, date: Date(), userRecordID: CKRecord.ID(), treeRecordID: CKRecord.ID()),
            Pin(image: UIImage(), latitude: 10.0, longitude: 10.0, date: Date(), userRecordID: CKRecord.ID(), treeRecordID: CKRecord.ID())
        ]
        
        let viewModel = MapViewModel(locationService: locationService,
                               pinService: pinService,
                               userService: userService,
                               scannedTreeService: treeService)

        await viewModel.onMapAppear()

        #expect(locationService.startCalled == true)
        #expect(viewModel.usablePins.isEmpty == false)
    }
    
    @Test func testGetPins() async throws {
        let locationService = MockLocationService()
        let pinService = MockPinService()
        let userService = MockUserService()
        let treeService = MockScannedTreeService()
        
        pinService.pins = [
            Pin(image: UIImage(), latitude: 1.0, longitude: 1.0, date: Date(), userRecordID: CKRecord.ID(), treeRecordID: CKRecord.ID()),
            Pin(image: UIImage(), latitude: 10.0, longitude: 10.0, date: Date(), userRecordID: CKRecord.ID(), treeRecordID: CKRecord.ID())
        ]

        let viewModel = MapViewModel(locationService: locationService,
                               pinService: pinService,
                               userService: userService,
                               scannedTreeService: treeService)
        
        await viewModel.getPins()
        
        #expect(viewModel.usablePins.count > 0)
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
        
        await viewModel.getPins()
        
        #expect(viewModel.usablePins.isEmpty)
    }
    
}
