//
//  ImageCache.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 07.01.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

@propertyWrapper
public struct ImageCache {
    // MARK: - Public Properties
    
    public var wrappedValue: ImageCacheProtocol {
        get { storage.imageCache }
        nonmutating set { storage.imageCache = newValue }
    }
    
    // MARK: - Private Properties
    
    private var storage: FeatureStorage
    
    // MARK: - Initializers
    
    public init() {
        storage = FeatureStorage.shared
    }
}
