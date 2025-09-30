//
//  CacheService.swift
//  Cerne
//
//  Created by Andrei Rech on 30/09/25.
//

import Foundation

class CacheService: CacheServiceProtocol {
    static let shared = CacheService()
    private let cache = NSCache<NSString, AnyObject>()
    
    private init() {}
    
    func set<T>(_ value: T, forKey key: CacheKey) {
        let entry = CacheEntry(value: value)
        
        cache.setObject(entry, forKey: key.stringValue as NSString)
        print("Valor salvo no cache para a chave: \(key.stringValue)")
    }
    
    func get<T>(forKey key: CacheKey) -> T? {
        print("Verificando cache para a chave: \(key.stringValue)")
        
        guard let entry = cache.object(forKey: key.stringValue as NSString) else {
            return nil
        }
        
        if let typedEntry = entry as? CacheEntry<T> {
            print("Valor encontrado no cache para chave: \(key.stringValue)")
            return typedEntry.value
        }
        
        return nil
    }
    
    func remove(forKey key: CacheKey) {
        cache.removeObject(forKey: key.stringValue as NSString)
        print("Dados removidos do cache para a chave: \(key.stringValue)")
    }
}
