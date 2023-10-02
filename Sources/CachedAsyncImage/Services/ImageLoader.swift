//
//  ImageLoader.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import Combine
import UIKit

final class ImageLoader: ObservableObject {
    // MARK: - Property Wrappers
    
    @Published var image: UIImage?
    @Published var progress: Double?
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let networkManager: NetworkManagerProtocol
    private let imageCache = TemporaryImageCache.shared
    
    private var cancellables: Set<AnyCancellable> = []
    private(set) var isLoading = false
    
    private static let imageProcessing = DispatchQueue(
        label: "com.cachedAsyncImage.imageProcessing"
    )
    
    // MARK: - Initializers
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    // MARK: - Deinitializers
    
    deinit {
        cancel()
    }
    
    // MARK: - Public Methods
    
    func fetchImage(from url: String) {
        guard !isLoading else { return }
        
        let url = URL(string: url)
        
        if let url = url, let cachedImage = imageCache[url] {
            image = cachedImage
            return
        }
        
        let (progress, data) = networkManager.fetchImage(from: url)
        
        progress?
            .publisher(for: \.fractionCompleted)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fractionCompleted in
                self?.progress = fractionCompleted
            }
            .store(in: &cancellables)
        
        data
            .map { UIImage(data: $0) }
            .catch { [weak self] error -> AnyPublisher<UIImage?, Never> in
                if let error = error as? NetworkError {
                    DispatchQueue.main.async {
                        self?.errorMessage = error.rawValue
                    }
                }
                
                return Just(nil).eraseToAnyPublisher()
            }
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    self?.start()
                },
                receiveOutput: { [weak self] in
                    self?.cache(url: url, image: $0)
                },
                receiveCompletion: { [weak self] _ in
                    self?.finish()
                },
                receiveCancel: { [weak self] in
                    self?.finish()
                }
            )
            .subscribe(on: Self.imageProcessing)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func start() {
        isLoading = true
    }
    
    private func finish() {
        isLoading = false
    }
    
    private func cache(url: URL?, image: UIImage?) {
        guard let url = url else { return }
        image.map { imageCache[url] = $0 }
    }
    
    private func cancel() {
        cancellables.forEach { $0.cancel() }
    }
}
