//
//  PinDetailsViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 10/09/25.
//

import Foundation

protocol PinDetailsViewModelProtocol {
    var pin: Pin { get }
    var details: TreeDetails? { get set }
    var isPinFromUser: Bool { get }
    var errorMessage: String? { get set }
    var reportEnabled: Bool { get }
    
    func deletePin(pin: Pin)
    func reportPin(to pin: Pin)
    func isPinFromUser() async
    func message() -> String
}
