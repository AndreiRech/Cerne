//
//  TreeReviewDTO.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation

class TreeReviewDTO {
    let createdTree: ScannedTree
    let createdPin: Pin

    init(createdTree: ScannedTree, createdPin: Pin) {
        self.createdTree = createdTree
        self.createdPin = createdPin
    }
}
