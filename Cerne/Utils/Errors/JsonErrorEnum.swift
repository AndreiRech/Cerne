//
//  JsonErrorEnum.swift
//  Cerne
//
//  Created by Andrei Rech on 11/09/25.
//

enum JsonError: Error {
    case fileNotFound
    case errorLoadingData
    case invalidJsonFormat
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Não foi possível encontrar o arquivo"
        case .errorLoadingData:
            return "Não foi possível carregar o conteúdo do arquivo"
        case .invalidJsonFormat:
            return "Erro ao decodificar o JSON"
        }
    }
}
