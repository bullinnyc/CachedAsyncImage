//
//  CachedAsyncImageTests.swift
//  CachedAsyncImageTests
//
//  Created by Dmitry Kononchuk on 24.10.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import XCTest
import SwiftUI
@testable import CachedAsyncImage

final class CachedAsyncImageTests: XCTestCase {
    func testInit_WithUrlAndImage() {
        let _ = CachedAsyncImage(
            url: "",
            image: { image in
                Image(uiImage: image)
            }
        )
    }
    
    func testInit_WithUrlAndPlaceholderAndImage() {
        let _ = CachedAsyncImage(
            url: "",
            placeholder: {
                Text("Downloading")
            },
            image: { image in
                Image(uiImage: image)
            }
        )
    }
    
    func testInit_WithUrlAndPlaceholderProgressAndImage() {
        let _ = CachedAsyncImage(
            url: "",
            placeholder: { progress in
                Text("Downloading \(progress) %")
            },
            image: { image in
                Image(uiImage: image)
            }
        )
    }
    
    func testInit_WithUrlAndImageAndError() {
        let _ = CachedAsyncImage(
            url: "",
            image: { image in
                Image(uiImage: image)
            },
            error: { error in
                Text(error)
            }
        )
    }
    
    func testInit_WithUrlAndPlaceholderAndImageAndError() {
        let _ = CachedAsyncImage(
            url: "",
            placeholder: {
                Text("Downloading")
            },
            image: { image in
                Image(uiImage: image)
            },
            error: { error in
                Text(error)
            }
        )
    }
    
    func testInit_WithUrlAndPlaceholderProgressAndImageAndError() {
        let _ = CachedAsyncImage(
            url: "",
            placeholder: { progress in
                Text("Downloading \(progress) %")
            },
            image: { image in
                Image(uiImage: image)
            },
            error: { error in
                Text(error)
            }
        )
    }
}
