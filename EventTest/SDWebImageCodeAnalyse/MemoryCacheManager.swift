//
//  NSCache+LazyLoad.swift
//  EventTest
//
//  Created by apple on 2021/1/26.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

class MemoryCacheManager {
    
    static let shared = MemoryCacheManager(cache: NSCache())
    
    let cache:NSCache<AnyObject, AnyObject>
    init(cache:NSCache<AnyObject, AnyObject>) {
        self.cache = cache
    }
    
    func object<T:AnyObject>(forKey:NSString,defaultValue:() -> T) -> T {
        if let r = cache.object(forKey: forKey) as? T {
            return r
        }
        let r = defaultValue()
        cache.setObject(r, forKey: forKey)
        return r
    }
    
    func set(object:NSString , forKey:AnyObject) {
        cache.setObject(object, forKey: forKey)
    }
    
    func object(forKey:NSString) -> AnyObject? {
        cache.object(forKey: forKey)
    }
}

extension DateFormatter {
    
    fileprivate struct CacheKey {
        static let `default` = "DateFormatter.default"
    }
    
   static var cachedDefaultFormatter: DateFormatter {
        return MemoryCacheManager.shared.object(forKey: CacheKey.default as NSString) {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return df
        }
    }
    
}
