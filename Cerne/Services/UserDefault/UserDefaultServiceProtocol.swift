//
//  UserDefaultServiceProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 22/09/25.
//

protocol UserDefaultServiceProtocol {
    func isFirstTime() -> Bool
    func setFirstTimeDone()
    func setPinReported(pin: Pin)
    func isPinReported(pin: Pin) -> Bool
}
