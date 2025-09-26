//
//  UserValidationError.swift
//  Cerne
//
//  Created by Andrei Rech on 25/09/25.
//

import Foundation

enum UserValidationError: Error, LocalizedError {
    case nameTooShort
    case invalidHeight

    var errorDescription: String? {
        switch self {
        case .nameTooShort:
            return "O nome de usuário deve ter pelo menos 4 caracteres."
        case .invalidHeight:
            return "A altura deve estar entre 1 e 3 metros."
        }
    }
}
