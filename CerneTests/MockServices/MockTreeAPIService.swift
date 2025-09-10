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
    var isCorret: Bool = true
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func identifyTree(image: UIImage) async throws -> TreeResponse {
        isCorret = !shouldFail
        
        if shouldFail {
            throw NetworkError.invalidResponse
        } else {
            return TreeResponse(bestMatch: "value")
        }
    }
}
