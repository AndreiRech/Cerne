//
//  ProfileViewModelProtocol.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 26/09/25.
//

import Foundation

protocol ProfileViewModelProtocol {
    var pinService: PinServiceProtocol { get }
    var userService: UserServiceProtocol { get }
    var footprintService: FootprintServiceProtocol { get }
    var userPins: [Pin] { get }
    var footprint: String? { get }
    var isLoading: Bool { get  set }
    var totalCO2: String { get }
    
    func fetchUserPins() async
    func fetchFootprint() async
    func deleteAccount() async
}
