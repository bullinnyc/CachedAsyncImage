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
        let url = "https://example.com/image.jpg"
        let cachedImage = RM.image("backToTheFuture")
        var imageCache = sut.imageCache
        let networkManager = sut.networkManager
        
        let imageLoader = ImageLoader(
            imageCache: imageCache,
            networkManager: networkManager
        )
        
        // When
        guard let imageUrl = URL(string: url) else {
            fatalError("Bad URL or nil.")
        }
        
        imageCache[imageUrl] = cachedImage
        imageLoader.fetchImage(from: url)
        
        // Then
        var imageLoaderImage: CPImage?
        
        switch imageLoader.state {
        case .loaded(let image):
            imageLoaderImage = image
        default:
            break
        }
        
        XCTAssertEqual(
            imageLoaderImage,
            cachedImage,
            "Image's should be equal."
        )
    }
    
    func testFetchImage_WithoutCachedImage() {
        // Given
        let url = "https://example.com/image.jpg"
        let imageCache = sut.imageCache
        let networkManager = sut.networkManager
        
        imageCache.removeCache()
        
        let imageLoader = ImageLoader(
            imageCache: imageCache,
            networkManager: networkManager
        )
        
        // When
        imageLoader.fetchImage(from: url)
        
        // Then
        guard let imageUrl = URL(string: url) else {
            fatalError("Bad URL or nil.")
        }
        
        let expectation = XCTestExpectation(description: "Fetch image.")
        
        let subscription = imageLoader.$state
            .sink { state in
                var imageLoaderImage: CPImage?
                
                switch state {
                case .loaded(let image):
                    imageLoaderImage = image
                default:
                    break
                }
                
                if imageLoaderImage != nil {
                    XCTAssertNotNil(
                        imageLoaderImage,
                        "Image should be not nil."
                    )
                    
                    XCTAssertNotNil(
                        imageCache[imageUrl],
                        "Image cache should be not nil."
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
        imageCache: ImageCacheProtocol,
        networkManager: NetworkProtocol
    )
    
    private func makeSUT() -> Sut {
        let imageCache = TemporaryImageCache()
        let networkManager = NetworkManagerMock()
        
        return (imageCache, networkManager)
    }
}
