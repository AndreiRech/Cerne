//
//  GenericErrorEnum.swift
//  Cerne
//
//  Created by Andrei Rech on 11/09/25.
//

enum GenericError: Error {
    case detailsNotFound
    
    var errorDescription: String? {
        switch self {
        case .detailsNotFound:
            return "Não achamos nenhum detalhes dessa árvore."
        }
    }
}
