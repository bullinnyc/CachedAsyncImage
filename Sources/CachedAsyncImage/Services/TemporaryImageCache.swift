//
//  TemporaryImageCache.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import Foundation

/// Temporary image cache.
public final class TemporaryImageCache {
    // MARK: - Public Properties
    
    /// The singleton instance.
    ///
    /// - Returns: The singleton `TemporaryImageCache` instance.
    public static let shared = TemporaryImageCache()
    
    // MARK: - Private Properties
    
    private lazy var cache: NSCache<NSURL, UnifiedImage> = {
        let cache = NSCache<NSURL, UnifiedImage>()
        return cache
    }()
    
    // MARK: - Subscripts
    
    subscript(_ key: URL) -> UnifiedImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            newValue == nil
                ? cache.removeObject(forKey: key as NSURL)
                : cache.setObject(newValue ?? UnifiedImage(), forKey: key as NSURL)
        }
    }
    
    // MARK: - Private Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Set cache limit.
    ///
    /// - Parameters:
    ///   - countLimit: The maximum number of objects the cache should hold.
    ///   If `0`, there is no count limit. The default value is `0`.
    ///   - totalCostLimit: The maximum total cost that the cache can hold before
    ///   it starts evicting objects.
    ///   When you add an object to the cache, you may pass in a specified cost for the object,
    ///   such as the size in bytes of the object.
    ///   If `0`, there is no total cost limit. The default value is `0`.
    public func setCacheLimit(countLimit: Int = 0, totalCostLimit: Int = 0) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }
    
    /// Empties the cache.
    public func removeCache() {
        cache.removeAllObjects()
    }
}
