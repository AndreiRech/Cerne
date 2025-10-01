//
//  MockCacheService.swift
//  CerneTests
//
//  Created by Andrei Rech on 01/10/25.
//

import Foundation
@testable import Cerne

class MockCacheService: CacheServiceProtocol {
    var cache: [String: Any] = [:]
    
    func set<T>(_ value: T, forKey key: CacheKey) {
        cache[key.stringValue] = value
    }
    
    func get<T>(forKey key: CacheKey) -> T? {
        return cache[key.stringValue] as? T
    }
    
    func remove(forKey key: CacheKey) {
        cache.removeValue(forKey: key.stringValue)
    }
    
    func clearCache() {
        cache.removeAll()
    }
}
