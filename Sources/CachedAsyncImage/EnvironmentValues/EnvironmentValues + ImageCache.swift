//
//  EnvironmentValues + ImageCache.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 26.11.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    // MARK: - Public Properties
    
    static var defaultValue: ImageCache {
        TempImageCache()
    }
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
