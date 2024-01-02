//
//  CachedAsyncImage.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

/// CachedAsyncImage view.
public struct CachedAsyncImage: View {
    // MARK: - Property Wrappers
    
    @StateObject private var imageLoader: ImageLoader
    
    // MARK: - Private Properties
    
    private let url: String
    private let placeholder: (() -> any View)?
    private let placeholderWithProgress: ((String) -> any View)?
    private let image: (CPImage) -> any View
    private let error: ((String) -> any View)?
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            if let uiImage = imageLoader.image {
                AnyView(image(uiImage))
            } else {
                errorOrPlaceholder
            }
        }
        .onChange(of: url) { _, newValue in
            imageLoader.fetchImage(from: newValue)
        }
        .onAppear {
            imageLoader.fetchImage(from: url)
        }
    }
    
    // MARK: - Initializers
    
    /// - Parameters:
    ///   - url: The URL for which to create a image.
    ///   - image: Image to be displayed.
    ///   - error: Error to be displayed.
    public init(
        url: String,
        image: @escaping (CPImage) -> any View,
        error: ((String) -> any View)? = nil
    ) {
        _imageLoader = StateObject(
            wrappedValue: ImageLoader(
                networkManager: NetworkManager.shared,
                imageCache: CachedAsyncImage.getImageCache()
            )
        )
        
        self.url = url
        self.image = image
        self.error = error
        
        placeholder = nil
        placeholderWithProgress = nil
    }
    
    /// - Parameters:
    ///   - url: The URL for which to create a image.
    ///   - placeholder: Placeholder to be displayed.
    ///   - image: Image to be displayed.
    ///   - error: Error to be displayed.
    public init(
        url: String,
        placeholder: (() -> any View)? = nil,
        image: @escaping (CPImage) -> any View,
        error: ((String) -> any View)? = nil
    ) {
        _imageLoader = StateObject(
            wrappedValue: ImageLoader(
                networkManager: NetworkManager.shared,
                imageCache: CachedAsyncImage.getImageCache()
            )
        )
        
        self.url = url
        self.placeholder = placeholder
        self.image = image
        self.error = error
        
        placeholderWithProgress = nil
    }
    
    /// - Parameters:
    ///   - url: The URL for which to create a image.
    ///   - placeholder: Placeholder with progress to be displayed.
    ///   - image: Image to be displayed.
    ///   - error: Error to be displayed.
    public init(
        url: String,
        placeholder: ((String) -> any View)? = nil,
        image: @escaping (CPImage) -> any View,
        error: ((String) -> any View)? = nil
    ) {
        _imageLoader = StateObject(
            wrappedValue: ImageLoader(
                networkManager: NetworkManager.shared,
                imageCache: CachedAsyncImage.getImageCache()
            )
        )
        
        self.url = url
        self.placeholder = nil
        self.image = image
        self.error = error
        
        placeholderWithProgress = placeholder
    }
    
    // MARK: - Private Methods
    
    /// Will be removed in future versions.
    private static func getImageCache() -> ImageCache {
        if isTemporaryImageCacheInitialized {
            TemporaryImageCache.shared
        } else {
            Environment(\.imageCache).wrappedValue
        }
    }
}

// MARK: - Ext. Configure views

extension CachedAsyncImage {
    @ViewBuilder
    private var errorOrPlaceholder: some View {
        if let error = error, let errorMessage = imageLoader.errorMessage {
            AnyView(error(errorMessage))
        } else {
            if let placeholder = placeholder {
                AnyView(placeholder())
            }
            
            if let placeholderWithProgress = placeholderWithProgress {
                let percentValue = Int((imageLoader.progress ?? .zero) * 100)
                let progress = String(percentValue)
                
                AnyView(placeholderWithProgress(progress))
            }
        }
    }
}

// MARK: - Preview Provider

struct CachedAsyncImage_Previews: PreviewProvider {
    static var placeholder: some View {
        ZStack {
            Color.yellow
            ProgressView()
        }
    }
    
    static func placeholderWithProgress(_ progress: String) -> some View {
        ZStack {
            Color.yellow
            
            ProgressView() {
                VStack {
                    Text("Downloading...")
                    Text("\(progress) %")
                }
            }
        }
    }
    
    static func image(_ image: CPImage) -> some View {
        Image(cpImage: image)
            .resizable()
            .scaledToFit()
    }
    
    static func error(_ error: String) -> some View {
        ZStack {
            Color.yellow
            
            VStack {
                Group {
                    Text("Error:")
                        .bold()
                    
                    Text(error)
                }
                .font(.footnote)
                .multilineTextAlignment(.center)
                .conditional { view in
                    if #available(iOS 15.0, macOS 12.0, *) {
                        view
                            .foregroundStyle(.red)
                    } else {
                        view
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
        }
    }
    
    static var previews: some View {
        let url = "https://image.tmdb.org/t/p/w1280/7lyBcpYB0Qt8gYhXYaEZUNlNQAv.jpg"
        
        Group {
            CachedAsyncImage(
                url: url,
                image: {
                    image($0)
                }
            )
            
            CachedAsyncImage(
                url: url,
                placeholder: {
                    placeholder
                },
                image: {
                    image($0)
                }
            )
            
            CachedAsyncImage(
                url: url,
                placeholder: {
                    placeholderWithProgress($0)
                },
                image: {
                    image($0)
                }
            )
            
            CachedAsyncImage(
                url: url,
                image: {
                    image($0)
                },
                error: {
                    error($0)
                }
            )
            
            CachedAsyncImage(
                url: url,
                placeholder: {
                    placeholder
                },
                image: {
                    image($0)
                },
                error: {
                    error($0)
                }
            )
            
            CachedAsyncImage(
                url: url,
                placeholder: {
                    placeholderWithProgress($0)
                },
                image: {
                    image($0)
                },
                error: {
                    error($0)
                }
            )
        }
        #if os(macOS)
        .frame(width: 300, height: 450)
        #endif
    }
}
