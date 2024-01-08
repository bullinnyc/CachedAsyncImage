//
//  ImageCache.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 07.01.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

/// A property wrapper type that reflects a value from `TemporaryImageCache`.
///
/// Read this value from within a view to access the image cache management.
///
///     struct MyView: View {
///         @ImageCache private var imageCache
///
///         // ...
///     }
///
@propertyWrapper
public struct ImageCache {
    // MARK: - Public Properties
    
    /// The wrapped value property provides primary access to the value’s data.
    public var wrappedValue: ImageCacheProtocol {
        get { storage.imageCache }
        nonmutating set { storage.imageCache = newValue }
    }
    
    // MARK: - Private Properties
    
    private let storage: FeatureStorage
    
    // MARK: - Initializers
    
    public init() {
        storage = FeatureStorage.shared
    }
}
