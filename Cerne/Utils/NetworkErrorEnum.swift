//
//  NetworkErrorEnum.swift
//  Cerne
//
//  Created by Andrei Rech on 10/09/25.
//

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case unsupportedImageType
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL da API inválida."
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Resposta inválida do servidor."
        case .decodingError:
            return "Erro ao processar os dados recebidos."
        case .unsupportedImageType:
            return "Formato de imagem não suportado."
        }
    }
}
