//
//  ImageLoaderTests.swift
//  CachedAsyncImageTests
//
//  Created by Dmitry Kononchuk on 17.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import XCTest
import Combine
@testable import CachedAsyncImage

final class ImageLoaderTests: XCTestCase {
    var sut: Sut!
    
    override func setUp() {
        super.setUp()

        sut = makeSUT()
    }
    
    override func tearDown() {
        sut = nil

        super.tearDown()
    }
    
    func testFetchImage_WithCachedImage() {
        // Given
        let imageUrl = URL(string: "https://example.com/image.jpg")
        let networkManager = sut.networkManager
        let imageCache = sut.imageCache
        let cachedImage = RM.image("backToTheFuture")
        
        let imageLoader = ImageLoader(
            url: imageUrl,
            networkManager: networkManager
        )
        
        // When
        guard let imageUrl = imageUrl else { fatalError("Bad URL or nil.") }
        
        imageCache[imageUrl] = cachedImage
        imageLoader.fetchImage()
        
        // Then
        XCTAssertNotNil(imageLoader.image, "Image should be not nil.")
        XCTAssertEqual(
            imageLoader.image,
            cachedImage,
            "Image's should be equal."
        )
        
        XCTAssertFalse(imageLoader.isLoading, "Loading should be false.")
    }
    
    func testFetchImage_WithoutCachedImage() {
        // Given
        let imageUrl = URL(string: "https://example.com/image.jpg")
        let networkManager = sut.networkManager
        let imageCache = sut.imageCache
        imageCache.removeCache()
        
        let imageLoader = ImageLoader(
            url: imageUrl,
            networkManager: networkManager
        )
        
        // When
        imageLoader.fetchImage()
        
        // Then
        guard let imageUrl = imageUrl else { fatalError("Bad URL or nil.") }
        
        XCTAssertNil(imageCache[imageUrl], "Image cache should be nil.")
        
        let expectation = XCTestExpectation(description: "Fetch image.")
        
        let subscription = imageLoader.$image
            .sink { image in
                if image != nil {
                    XCTAssertNotNil(
                        image,
                        "Image should be not nil."
                    )
                    
                    XCTAssertNotNil(
                        imageCache[imageUrl],
                        "Image cache should be not nil."
                    )
                    
                    XCTAssertFalse(
                        imageLoader.isLoading,
                        "Loading should be false."
                    )
                    
                    expectation.fulfill()
                }
            }
        
        wait(for: [expectation], timeout: 1)
        subscription.cancel()
    }
}

extension ImageLoaderTests {
    typealias Sut = (
        networkManager: NetworkManagerProtocol,
        imageCache: TemporaryImageCache
    )
    
    private func makeSUT() -> Sut {
        let networkManager = NetworkManagerMock.shared
        let imageCache = TemporaryImageCache.shared
        
        return (networkManager, imageCache)
    }
}
