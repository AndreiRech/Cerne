//
//  FootprintDTO.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation

class FootprintDTO {
    let currentUser: User
    let userFootprint: Footprint?
    let responses: [Response]
    
    init(currentUser: User, userFootprint: Footprint?, responses: [Response]) {
        self.currentUser = currentUser
        self.userFootprint = userFootprint
        self.responses = responses
    }
}
