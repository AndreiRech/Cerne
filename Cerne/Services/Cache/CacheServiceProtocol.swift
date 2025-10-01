//
//  CacheServiceProtocol.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

protocol CacheServiceProtocol {
    func set<T>(_ value: T, forKey key: CacheKey)
    func get<T>(forKey key: CacheKey) -> T?
    func remove(forKey key: CacheKey)
}
