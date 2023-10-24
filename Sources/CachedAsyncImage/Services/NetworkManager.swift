//
//  NetworkManager.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import Foundation
import Combine

enum NetworkError: LocalizedError {
    // Invalid request, e.g. invalid URL.
    case badURL(String = "Bad URL or nil.")
    
    // Indicates an error on the transport layer,
    // e.g. not being able to connect to the server.
    case transportError(Error)
    
    // Received an bad response, e.g. non HTTP result.
    case badResponse(String)
    
    var rawValue: String {
        switch self {
        case .badURL(let message):
            return message
        case .transportError(let error):
            return error.localizedDescription
        case .badResponse(let message):
            return message
        }
    }
}

protocol NetworkManagerProtocol {
    func fetchImage(from url: URL?) -> (
        progress: Progress?,
        publisher: AnyPublisher<Data, Error>
    )
}

final class NetworkManager: NetworkManagerProtocol {
    // MARK: - Public Properties
    
    static let shared = NetworkManager()
    
    // MARK: - Private Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchImage(from url: URL?) -> (
        progress: Progress?,
        publisher: AnyPublisher<Data, Error>
    ) {
        guard let url = url else {
            return (nil, Fail(error: NetworkError.badURL())
                .eraseToAnyPublisher())
        }
        
        let sharedPublisher = URLSession.shared
            .dataTaskProgressPublisher(for: url)
        
        let progress = sharedPublisher
            .progress
        
        let result = sharedPublisher
            .publisher
            // Handle transport layer errors.
            .mapError { NetworkError.transportError($0) }
            // Handle all other errors.
            .tryMap { element in
                if let httpResponse = element.response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    throw NetworkError.badResponse(
                        "Bad response. Status code: \(httpResponse.statusCode)"
                    )
                }
                
                return element.data
            }
            .eraseToAnyPublisher()
        
        return (progress, result)
    }
}

// MARK: - Ext. URLSession

extension URLSession {
    // MARK: - Typealias
    
    typealias DataTaskProgressPublisher = (
        progress: Progress?,
        publisher: AnyPublisher<DataTaskPublisher.Output, Error>
    )
    
    // MARK: - Public Methods
    
    func dataTaskProgressPublisher(for url: URL) -> DataTaskProgressPublisher {
        let progress = Progress(totalUnitCount: 1)
        
        let result = Deferred {
            Future<DataTaskPublisher.Output, Error> { handler in
                let task = self.dataTask(
                    with: URLRequest(url: url)
                ) { data, response, error in
                    if let error = error {
                        handler(.failure(error))
                    } else if let data = data, let response = response {
                        handler(.success((data, response)))
                    }
                }
                
                progress.addChild(task.progress, withPendingUnitCount: 1)
                task.resume()
            }
        }
        .share()
        .eraseToAnyPublisher()
        
        return (progress, result)
    }
}
