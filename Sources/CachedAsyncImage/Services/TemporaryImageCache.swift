//
//  TemporaryImageCache.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import UIKit

/// Temporary image cache.
public final class TemporaryImageCache {
    // MARK: - Public Properties
    
    public static let shared = TemporaryImageCache()
    
    // MARK: - Private Properties
    
    private lazy var cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        return cache
    }()
    
    // MARK: - Subscripts
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            newValue == nil
                ? cache.removeObject(forKey: key as NSURL)
                : cache.setObject(newValue ?? UIImage(), forKey: key as NSURL)
        }
    }
    
    // MARK: - Private Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    public func setCacheLimit(countLimit: Int, totalCostLimit: Int) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }
    
    public func removeCache() {
        cache.removeAllObjects()
    }
}
