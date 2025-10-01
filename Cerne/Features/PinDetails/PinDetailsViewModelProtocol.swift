//
//  PinDetailsViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 10/09/25.
//

import Foundation

protocol PinDetailsViewModelProtocol {
    var pin: Pin { get }
    var tree: ScannedTree? { get }
    var pinUser: User? { get }
    var user: User? { get }
    
    var details: TreeDetails? { get set }
    var isPinFromUser: Bool { get }
    var errorMessage: String? { get set }
    var reportEnabled: Bool { get }
    var formattedTotalCO2: String { get }
    var isLoading: Bool { get }
    
    func deletePin() async
    func reportPin() async
    func message() -> String
    func fetchData() async
}
