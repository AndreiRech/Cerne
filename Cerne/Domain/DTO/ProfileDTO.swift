//
//  ProfileDTO.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation

class ProfileDTO {
    let currentUser: User
    let allPins: [Pin]
    let allTrees: [ScannedTree]
    let userFootprint: Footprint?
    
    init(currentUser: User, allPins: [Pin], allTrees: [ScannedTree], userFootprint: Footprint?) {
        self.currentUser = currentUser
        self.allPins = allPins
        self.allTrees = allTrees
        self.userFootprint = userFootprint
    }
}
