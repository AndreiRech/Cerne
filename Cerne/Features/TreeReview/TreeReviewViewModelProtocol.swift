//
//  TreeReviewViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 12/09/25.
//

import Foundation
import UIKit

protocol TreeReviewViewModelProtocol {
    var cameraService: CameraServiceProtocol { get }
    var scannedTreeService: ScannedTreeServiceProtocol { get }
    var treeAPIService: TreeAPIServiceProtocol { get }
    var pinService: PinServiceProtocol { get }
    var pinLatitude: Double { get }
    var pinLongitude: Double { get }
//    var pinUser: User { get }
    var updateSpecies: String { get set }
    var updateHeight: Double  { get set }
    var updateDap: Double  { get set }
    var measuredDiameter: Double { get }
    var treeImage: UIImage? { get }
    var estimatedHeight: Double { get }
    var errorMessage: String? { get set }
    
    func createScannedTree() async
    func calculateCO2(height: Double, dap: Float, density: Double) -> Double
    func calculateBiomass(height: Double, dap: Float, density: Double) -> Double
    func createPin() async
    func updateScannedTree() async
    func cancel()
}
