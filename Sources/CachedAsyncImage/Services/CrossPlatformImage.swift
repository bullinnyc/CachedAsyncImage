//
//  CrossPlatformImage.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 01.11.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

#if os(iOS)
import UIKit
import SwiftUI

/// Cross platform image typealias.
public typealias CPImage = UIImage

extension Image {
    /// - Parameter cpImage: Cross platform image.
    public init(cpImage: CPImage) {
        self.init(uiImage: cpImage)
    }
}

extension UIImage {
    var data: Data? {
        pngData()
    }
}
#elseif os(macOS)
import AppKit
import SwiftUI

/// Cross platform image typealias.
public typealias CPImage = NSImage

extension Image {
    /// - Parameter cpImage: Cross platform image.
    public init(cpImage: CPImage) {
        self.init(nsImage: cpImage)
    }
}

extension NSImage {
    var data: Data? {
        tiffRepresentation
    }
}
#endif
