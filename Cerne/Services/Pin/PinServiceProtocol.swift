//
//  PinServiceProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import SwiftData

protocol PinServiceProtocol {
    var details: [TreeDetails] { get }
    
    func fetchPins() throws -> [Pin]
    func createPin(image: Data, latitude: Double, longitude: Double, user: User, tree: ScannedTree) throws
    func addReport(to pin: Pin) throws
    func deletePin(pin: Pin) throws
    func getDetails(fileName: String) throws -> [TreeDetails]
    func getDetails(for tree: ScannedTree) throws -> TreeDetails
}
