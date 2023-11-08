//
//  Extension + View.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 04.11.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

extension View {
    // MARK: - Public Methods
    
    /// Used, e.g. to use the if #available statement.
    ///
    ///     .conditional { view in
    ///         if #available(iOS 16.0, *) {
    ///             view
    ///                 .tint(cursorColor)
    ///         } else {
    ///             view
    ///                 .accentColor(cursorColor)
    ///         }
    ///
    /// - Parameter transform: The transform to apply to the source `View`.
    ///
    /// - Returns: Either the original `View` or the modified `View`.
    func conditional<Content: View>(
        @ViewBuilder transform: (Self) -> Content
    ) -> Content {
        transform(self)
    }
}
