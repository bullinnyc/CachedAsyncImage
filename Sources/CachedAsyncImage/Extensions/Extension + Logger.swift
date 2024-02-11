//
//  Extension + Logger.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 24.01.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import OSLog

typealias Log = Logger

extension Logger {
    // MARK: - Public Properties
    
    /// Log of failure.
    static let failure = Logger(subsystem: subsystem, category: "failure")
    
    // MARK: - Private Properties
    
    private static let subsystem = Bundle.module.bundleIdentifier ?? ""
}
