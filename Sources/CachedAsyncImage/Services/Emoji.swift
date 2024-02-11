//
//  Emoji.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 25.01.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation

final class Emoji {
    // MARK: - Public Enums
    
    enum Code: String {
        case hammer = "1f528"
    }
    
    // MARK: - Public Methods
    
    static func getEmoji(from code: Code) -> String? {
        guard let number = Int(code.rawValue, radix: 16),
              let unicodeScalar = UnicodeScalar(number)
        else { return nil }
        
        return String(unicodeScalar)
    }
}
