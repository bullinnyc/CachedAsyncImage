//
//  EnvironmentValues + ImageCache.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 02.01.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    // MARK: - Public Properties
    
    static let defaultValue: ImageCache = TempImageCache()
}

extension EnvironmentValues {
    // MARK: - Public Properties
    
    /// The image cache of this environment.
    ///
    /// Read this environment value from within a view to access the image cache management.
    ///
    ///     struct MyView: View {
    ///         @Environment(\.imageCache) private var imageCache
    ///
    ///         // ...
    ///     }
    public var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
