//
//  CacheEntry.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation

final class CacheEntry<T> {
    let value: T
    
    init(value: T) {
        self.value = value
    }
}
