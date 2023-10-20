//
//  NetworkManagerMock.swift
//  CachedAsyncImageTests
//
//  Created by Dmitry Kononchuk on 18.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import Foundation
import Combine
@testable import CachedAsyncImage

final class NetworkManagerMock: NetworkManagerProtocol {
    // MARK: - Public Properties
    
    static let shared = NetworkManagerMock()
    
    // MARK: - Private Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchImage(from url: URL?) -> (
        progress: Progress?,
        publisher: AnyPublisher<Data, Error>
    ) {
        guard url != nil else {
            return (nil, Fail(error: NetworkError.badURL())
                .eraseToAnyPublisher())
        }
        
        let image = RM.image("backToTheFuture")
        
        guard let image = image else {
            fatalError("Unable to get image.")
        }
        
        guard let imageData = image.pngData() else {
            fatalError("Unable to get data.")
        }
        
        let progress: Progress? = Progress(totalUnitCount: 1)
        
        let result = Just(imageData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        return (progress, result)
    }
}
