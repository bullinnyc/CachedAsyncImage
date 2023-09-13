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
    case badResponse(String = "Bad response.")
}

protocol NetworkManagerProtocol {
    func fetchImage(from url: URL?) -> AnyPublisher<Data, Error>
}

final class NetworkManager: NetworkManagerProtocol {
    // MARK: - Public Properties
    
    static let shared = NetworkManager()
    
    // MARK: - Private Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchImage(from url: URL?) -> AnyPublisher<Data, Error> {
        guard let url = url else {
            return Fail(error: NetworkError.badURL()).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
             // Handle transport layer errors.
            .mapError { NetworkError.transportError($0) }
             // Handle all other errors.
            .tryMap { tuple in
                guard let urlResponse = tuple.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse()
                }
                
                #if DEBUG
                    let message = """
                    **** CachedAsyncImage response.
                    From: \(urlResponse.url?.absoluteString ?? "")
                    Status code: \(urlResponse.statusCode)
                    """
                    
                    print(message)
                #endif
                
                return tuple.data
            }
            .eraseToAnyPublisher()
    }
}
