//
//  TemporaryImageCache.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import Foundation

/// Image cache protocol.
public protocol ImageCacheProtocol {
    subscript(_ url: URL) -> CPImage? { get set }
    
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
    func setCacheLimit(countLimit: Int, totalCostLimit: Int)
    
    /// Empties the cache.
    func removeCache()
}

struct TemporaryImageCache: ImageCacheProtocol {
    // MARK: - Private Properties
    
    private let cache: NSCache<NSURL, CPImage> = {
        let cache = NSCache<NSURL, CPImage>()
        return cache
    }()
    
    // MARK: - Subscripts
    
    subscript(_ key: URL) -> CPImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            newValue == nil
                ? cache.removeObject(forKey: key as NSURL)
                : cache.setObject(newValue ?? CPImage(), forKey: key as NSURL)
        }
    }
    
    // MARK: - Public Methods
    
    func setCacheLimit(countLimit: Int = 0, totalCostLimit: Int = 0) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }
    
    func removeCache() {
        cache.removeAllObjects()
    }
}
