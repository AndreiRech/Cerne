//
//  PinServiceProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 08/09/25.
//

import Foundation
import UIKit

protocol PinServiceProtocol {
    var details: [TreeDetails] { get }
    
    func fetchPins() async throws -> [Pin]
    func createPin(image: UIImage, latitude: Double, longitude: Double, user: User, tree: ScannedTree) async throws -> Pin
    func addReport(to pin: Pin) async throws -> Pin?
    func deletePin(_ pin: Pin) async throws
    
    func getDetails(fileName: String) throws -> [TreeDetails]
    func getDetails(for tree: ScannedTree) throws -> TreeDetails
}
