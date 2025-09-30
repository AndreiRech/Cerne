//
//  ValidationViewModel.swift
//  Cerne
//
//  Created by Maria Santellano on 30/09/25.
//

import SwiftUI
import Combine

@Observable
class ValidationViewModel: ValidationViewModelProtocol {
    var tree: ScannedTree?

    init(tree: ScannedTree? = nil) {
           self.tree = tree
       }
}
