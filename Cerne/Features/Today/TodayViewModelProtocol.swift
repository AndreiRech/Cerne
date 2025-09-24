//
//  TodayViewModelProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 23/09/25.
//

import Foundation

protocol TodayViewModelProtocol {
    var pinService: PinServiceProtocol { get }
    var userService: UserServiceProtocol { get }
    var userPins: [Pin] { get }
    
    func fetchUserPins() async
}
