//
//  TreeDataServiceProtocol.swift
//  Cerne
//
//  Created by Maria Santellano on 17/09/25.
//
// TreeDataServiceProtocol.swift

import Foundation

protocol TreeDataServiceProtocol {
    func findTree(byScientificName name: String) -> TreeDetails?
}

