//
//  MockTreeAPIService.swift
//  Cerne
//
//  Created by Andrei Rech on 10/09/25.
//

@testable import Cerne
import Foundation
import UIKit

class MockTreeAPIService: TreeAPIServiceProtocol {
    var shouldFail: Bool = false
    var isNetworkError: Bool = false
    var isCorret: Bool = true
    
    init(shouldFail: Bool = false, isNetworkError: Bool = false) {
        self.shouldFail = shouldFail
        self.isNetworkError = isNetworkError
    }
    
    func identifyTree(image: UIImage) async throws -> TreeResponse {
        isCorret = !shouldFail
        
        if shouldFail {
            if isNetworkError {
                throw NetworkError.invalidResponse
            } else {
                throw NSError(domain: "error", code: 0, userInfo: nil)
            }
        } else {
            return TreeResponse(bestMatch: "value")
        }
    }
}
