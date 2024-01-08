//
//  FeatureStorage.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 07.01.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

final class FeatureStorage {
    // MARK: - Public Properties
    
    var imageCache: ImageCacheProtocol = TemporaryImageCache()
    var network: NetworkProtocol = NetworkManager()
    
    static let shared = FeatureStorage()
    
    // MARK: - Private Initializers
    
    private init() {}
}
