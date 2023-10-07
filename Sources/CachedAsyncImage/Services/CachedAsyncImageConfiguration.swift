//
//  CachedAsyncImageConfiguration.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 04.10.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import Foundation

/// CachedAsyncImage configuration.
public final class CachedAsyncImageConfiguration {
    // MARK: - Public Properties
    
    /// The singleton instance.
    ///
    /// - Returns: The singleton `CachedAsyncImageConfiguration` instance.
    public static let shared = CachedAsyncImageConfiguration()
    
    // MARK: - Private Properties
    
    private(set) lazy var loggerLevel: LoggerLevel = .min
    
    // MARK: - Public Enums
    
    /// Logger level.
    public enum LoggerLevel {
        case min
        case max
    }
    
    // MARK: - Private Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Set logger level for debug.
    ///
    /// - Parameter level: Logger level.
    ///   Level `min`, only error messages are logged to the Xcode console.
    ///   Level `max`, all messages are logged to the Xcode console.
    public func setLogger(with level: LoggerLevel) {
        loggerLevel = level
    }
}
