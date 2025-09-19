//
//  GenericErrorEnum.swift
//  Cerne
//
//  Created by Andrei Rech on 11/09/25.
//

enum GenericError: Error {
    case detailsNotFound
    case serviceError
    
    var errorDescription: String? {
        switch self {
        case .detailsNotFound:
            return "Não achamos nenhum detalhes dessa árvore."
        case .serviceError:
            return "Ocorreu um erro durante o processo de utilizar os serviços do banco de dados."
        }
    }
}
