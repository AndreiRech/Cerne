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

    var measuredDiameter: Float { get }
    var treeImage: UIImage? { get }
    var estimatedHeight: Double { get }
    var errorMessage: String? { get set }
    
    func createScannedTree() async
    func calculateCO2(height: Double, dap: Float, density: Double) -> Double
    func calculateBiomass(height: Double, dap: Float, density: Double) -> Double
    func createPin()
    func editScannedTree()
    func cancel() //Pensar. eu preciso dessa cancel aq? pq seria so nao salvar uma tree ne
}
