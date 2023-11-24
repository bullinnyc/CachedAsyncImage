//
//  OnChange.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 23.11.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct OnChange<Value>: ViewModifier where Value: Equatable {
    // MARK: - Public Properties
    
    let value: Value
    let isInitial: Bool
    let action: (_ oldValue: Value?, _ newValue: Value) -> Void
    
    // MARK: - Body Method
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            content
                .onChange(of: value, initial: isInitial) { oldValue, newValue in
                    action(oldValue, newValue)
                }
        } else {
            content
                .onChange(of: value) { newValue in
                    action(nil, newValue)
                }
        }
    }
}

// MARK: - Ext. View

extension View {
    /// Method overloading – onChange(of:initial:_:).
    /// Adds a modifier for this view that fires an action when a specific value changes.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - isInitial: Whether the action should be run when this view initially appears.
    ///   - action: A closure to run when the value changes.
    ///   - oldValue: The old value that failed the comparisoncheck
    ///   (or the initial value when requested).
    ///   - newValue: The new value that failed the comparison check.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    func onChange<Value>(
        of value: Value,
        isInitial: Bool = false,
        action: @escaping (_ oldValue: Value?, _ newValue: Value) -> Void
    ) -> some View where Value: Equatable {
        modifier(OnChange(value: value, isInitial: isInitial, action: action))
    }
}
