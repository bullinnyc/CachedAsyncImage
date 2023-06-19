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
    
    // MARK: - Private Properties
    
    private let url: URL?
    private let networkManager: NetworkManagerProtocol
    private let imageCache = TemporaryImageCache.shared
    
    private var cancellable: AnyCancellable?
    private(set) var isLoading = false
    
    private static let imageProcessing = DispatchQueue(label: "imageProcessing")
    
    // MARK: - Initializers
    
    init(
        url: URL?,
        networkManager: NetworkManagerProtocol
    ) {
        self.url = url
        self.networkManager = networkManager
    }
    
    // MARK: - Deinitializers
    
    deinit {
        cancel()
    }
    
    // MARK: - Public Methods
    
    func fetchImage() {
        guard !isLoading else { return }
        
        if let url = url, let cachedImage = imageCache[url] {
            image = cachedImage
            return
        }
        
        cancellable = networkManager.fetchImage(from: url)
            .map { UIImage(data: $0) }
            .replaceError(with: nil)
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    self?.start()
                },
                receiveOutput: { [weak self] in
                    self?.cache($0)
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
    }
    
    // MARK: - Private Methods
    
    private func start() {
        isLoading = true
    }
    
    private func finish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        guard let url = url else { return }
        image.map { imageCache[url] = $0 }
    }
    
    private func cancel() {
        cancellable?.cancel()
    }
}
