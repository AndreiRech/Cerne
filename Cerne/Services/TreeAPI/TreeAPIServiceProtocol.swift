//
//  TreeAPIServiceProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 10/09/25.
//

import UIKit

protocol TreeAPIServiceProtocol {
    func identifyTree(image: UIImage) async throws -> TreeResponse
}
