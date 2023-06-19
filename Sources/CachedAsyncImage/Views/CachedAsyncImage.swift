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
    
    private let placeholder: () -> any View
    private let image: (UIImage) -> any View
    
    // MARK: - Body
    
    public var body: some View {
        content
            .onAppear {
                imageLoader.fetchImage()
            }
    }
    
    // MARK: - Initializers
    
    /// - Parameters:
    ///   - url: The URL for which to create a image.
    ///   - placeholder: Image placeholder.
    ///   - image: Image to be displayed.
    public init(
        url: String,
        placeholder: @escaping () -> any View,
        image: @escaping (UIImage) -> any View
    ) {
        _imageLoader = StateObject(
            wrappedValue: ImageLoader(
                url: URL(string: url),
                networkManager: NetworkManager.shared
            )
        )
        
        self.placeholder = placeholder
        self.image = image
    }
}

// MARK: - Ext. Configure views

extension CachedAsyncImage {
    @ViewBuilder
    private var content: some View {
        if let uiImage = imageLoader.image {
            AnyView(image(uiImage))
        } else {
            AnyView(placeholder())
        }
    }
}

// MARK: - Preview Provider

struct CachedAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        let url = "https://image.tmdb.org/t/p/w1280/7lyBcpYB0Qt8gYhXYaEZUNlNQAv.jpg"
        
        ZStack {
            CachedAsyncImage(
                url: url,
                placeholder: {
                    ZStack {
                        Color.yellow
                        ProgressView()
                    }
                },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                        .scaledToFit()
                }
            )
        }
    }
}
