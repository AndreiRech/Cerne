//
//  TreeReviewViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 12/09/25.
//

import Foundation
import UIKit

protocol TreeReviewViewModelProtocol {
    var updateSpecies: String { get set }
    var updateHeight: Double  { get set }
    var updateDap: Double  { get set }
    var errorMessage: String? { get set }
    
    func createScannedTree() async
    func updateScannedTree() async
    func cancel()
}
