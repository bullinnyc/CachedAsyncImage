//
//  Network.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 07.01.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

@propertyWrapper
struct Network {
    // MARK: - Public Properties
    
    var wrappedValue: NetworkProtocol {
        get { storage.network }
        nonmutating set { storage.network = newValue }
    }
    
    // MARK: - Private Properties
    
    private var storage: FeatureStorage
    
    // MARK: - Initializers
    
    init() {
        storage = FeatureStorage.shared
    }
}
