//
//  DataExtension.swift
//  Cerne
//
//  Created by Andrei Rech on 10/09/25.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
