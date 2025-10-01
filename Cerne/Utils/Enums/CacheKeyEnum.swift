//
//  CacheKeyEnum.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation

enum CacheKey {
    case currentUser
    case allPins
    case allScannedTrees
    case userFootprint
    case responses
    
    var stringValue: String {
        switch self {
        case .currentUser:
            return "current_user"
        case .allPins:
            return "all_pins"
        case .allScannedTrees:
            return "all_scanned_trees"
        case .userFootprint:
            return "user_footprint"
        case .responses:
            return "responses"
        }
    }
}
