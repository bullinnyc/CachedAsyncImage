//
//  TemporaryImageCache.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import Foundation

/// Will be removed in future versions.
var isTemporaryImageCacheInitialized = false

/// Temporary image cache.
@available(
    *,
    deprecated,
    message: "Will be removed in future versions. Use Environment with key path 'imageCache' property."
)
public final class TemporaryImageCache: ImageCache {
    // MARK: - Public Properties
    
    /// The singleton instance.
    ///
    /// - Returns: The singleton `TemporaryImageCache` instance.
    public static let shared = TemporaryImageCache()
    
    // MARK: - Private Properties
    
    private let cache: NSCache<NSURL, CPImage> = {
        let cache = NSCache<NSURL, CPImage>()
        return cache
    }()
    
    // MARK: - Subscripts
    
    public subscript(_ key: URL) -> CPImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            newValue == nil
                ? cache.removeObject(forKey: key as NSURL)
                : cache.setObject(newValue ?? CPImage(), forKey: key as NSURL)
        }
    }
    
    // MARK: - Private Initializers
    
    private init() {
        isTemporaryImageCacheInitialized = true
    }
    
    // MARK: - Public Methods
    
    public func setCacheLimit(countLimit: Int = 0, totalCostLimit: Int = 0) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }
    
    public func removeCache() {
        cache.removeAllObjects()
    }
}
