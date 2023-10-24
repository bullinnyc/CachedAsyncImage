//
//  ResourcesManager.swift
//  CachedAsyncImageTests
//
//  Created by Dmitry Kononchuk on 18.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//


import SwiftUI

/// Resources manager typealias.
public typealias RM = ResourcesManager

/// Resources manager.
public final class ResourcesManager {
    // MARK: - Public Methods
    
    /// Get image by name.
    ///
    /// - Parameter name: Image name.
    ///
    /// - Returns: An initialized image object or `nil` if the object was not found in the resources.
    public static func image(_ name: String) -> UnifiedImage? {
        UnifiedImage(named: name, in: Bundle.module)
    }
}

#if canImport(UIKit)
import UIKit

/// Resources manager.
extension ResourcesManager {
    // MARK: - Public Properties
    
    /// An object that stores color data.
    public static let snow = UIColor(
        named: "snow",
        in: Bundle.module,
        compatibleWith: nil
    ) ?? UIColor()
}
#elseif canImport(AppKit)
import AppKit

/// Resources manager.
extension ResourcesManager {
    // MARK: - Public Properties
    
    /// An object that stores color data.
    public static let snow = NSColor(
        named: "snow", bundle: Bundle.module
    ) ?? NSColor()
}

#endif
