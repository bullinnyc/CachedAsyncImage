//
//  ResourcesManager.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 18.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

#if canImport(UIKit)
import UIKit

/// Resources manager typealias.
public typealias RM = ResourcesManager

/// Resources manager.
public final class ResourcesManager {
    // MARK: - Public Properties
    
    /// An object that stores color data.
    public static let snow = UIColor(
        named: "snow",
        in: Bundle.module,
        compatibleWith: nil
    ) ?? UIColor()
    
    // MARK: - Public Methods
    
    /// Get image by name.
    ///
    /// - Parameter name: Image name.
    ///
    /// - Returns: An initialized image object or `nil` if the object was not found in the resources.
    public static func image(_ name: String) -> UIImage? {
        UIImage(named: name, in: Bundle.module, with: nil)
    }
}
#elseif canImport(AppKit)
import AppKit

/// Resources manager typealias.
public typealias RM = ResourcesManager

/// Resources manager.
public final class ResourcesManager {
    // MARK: - Public Properties
    
    /// An object that stores color data.
    public static let snow = NSColor(
        named: NSColor.Name("snow"),
        bundle: Bundle.module
    ) ?? NSColor()
    
    // MARK: - Public Methods
    
    /// Get image by name.
    ///
    /// - Parameter name: Image name.
    ///
    /// - Returns: An initialized image object or `nil` if the object was not found in the resources.
    public static func image(_ name: String) -> NSImage? {
        Bundle.module.image(forResource: NSImage.Name(name))
    }
}
#endif
