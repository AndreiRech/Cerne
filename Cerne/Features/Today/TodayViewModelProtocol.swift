//
//  TodayViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import Foundation
@MainActor

protocol TodayViewModelProtocol {
    var pinService: PinServiceProtocol { get }
    var userService: UserServiceProtocol { get }
    var userPins: [Pin] { get }
    var isLoading: Bool { get  set }
    
    func fetchUserPins() async
}
