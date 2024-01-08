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

struct NetworkManagerMock: NetworkProtocol {
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
        
        guard let imageData = image?.data else {
            fatalError("Unable to get data.")
        }
        
        let progress: Progress? = Progress(totalUnitCount: 1)
        
        let result = Just(imageData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        return (progress, result)
    }
}
