//
//  PinDetailsViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 10/09/25.
//

import Foundation

protocol PinDetailsViewModelProtocol {
    var pin: Pin? { get }
    
    func fetchPin(id: UUID)
    func deletePin(pin: Pin)
    func reportPin(to pin: Pin)
    func sharePin()
}
