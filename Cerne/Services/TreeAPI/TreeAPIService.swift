//
//  TreeAPIService.swift
//  Cerne
//
//  Created by Andrei Rech on 10/09/25.
//

import Foundation
import UIKit

class TreeAPIService: TreeAPIServiceProtocol {
    private let baseURL = "https://my-api.plantnet.org/v2/identify/all"
    private let apiKey = "2b10akcbJ8pFlAsoMWK12i8mee"
    
    func identifyTree(image: UIImage) async throws -> TreeResponse {
        guard let url = URL(string: "\(baseURL)?api-key=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NetworkError.unsupportedImageType
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = createBody(boundary: boundary, imageData: imageData)
        
        request.httpBody = httpBody
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TreeResponse.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    private func createBody(boundary: String, imageData: Data) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"images\"; filename=\"plant.jpg\"\(lineBreak)")
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
        body.append(imageData)
        body.append(lineBreak)
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}
