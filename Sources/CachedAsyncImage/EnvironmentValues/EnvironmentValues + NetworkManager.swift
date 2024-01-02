//
//  EnvironmentValues + NetworkManager.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 02.01.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct NetworkManagerKey: EnvironmentKey {
    // MARK: - Public Properties
    
    static let defaultValue: NetworkManagerProtocol = NetworkManager()
}

extension EnvironmentValues {
    // MARK: - Public Properties
    
    var networkManager: NetworkManagerProtocol {
        get { self[NetworkManagerKey.self] }
        set { self[NetworkManagerKey.self] = newValue }
    }
}
