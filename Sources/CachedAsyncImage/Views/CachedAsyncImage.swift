//
//  CachedAsyncImage.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

/// CachedAsyncImage view.
public struct CachedAsyncImage<Content:View, PlaceholderView:View, ErrorView: View>: View {
    // MARK: - Property Wrappers
    
    @StateObject private var imageLoader: ImageLoader
    
    // MARK: - Private Properties
    
    private let url: String
    private let placeholder: (() -> PlaceholderView)?
    private let placeholderWithProgress: ((String) -> PlaceholderView)?
    private let image: (Image) -> Content
    private let error: ((String) -> ErrorView)?
    
    // MARK: - Body
    
    public var body: some View {
        content
            .onChange(of: url, perform: { imageLoader.fetchImage(from: $0) })
            .onAppear {
                imageLoader.fetchImage(from: url)
            }
    }
    
    // MARK: - Initializers
    
    /// - Parameters:
    ///   - url: The URL for which to create a image.
    ///   - placeholder: Placeholder to be displayed.
    ///   - image: Image to be displayed.
    ///   - error: Error to be displayed.
    public init(
        url: String,
        placeholder: (() -> PlaceholderView)? = nil,
        image: @escaping (Image) -> Content,
        error: ((String) -> ErrorView)? = nil
    ) {
        _imageLoader = StateObject(
            wrappedValue: ImageLoader(networkManager: NetworkManager.shared)
        )
        
        self.url = url
        self.placeholder = placeholder
        self.image = image
        self.error = error
        
        self.placeholderWithProgress = nil
    }
    
    /// - Parameters:
    ///   - url: The URL for which to create a image.
    ///   - placeholder: Placeholder with progress to be displayed.
    ///   - image: Image to be displayed.
    ///   - error: Error to be displayed.
    public init(
        url: String,
        placeholder: ((String) -> PlaceholderView)? = nil,
        image: @escaping (Image) -> Content,
        error: ((String) -> ErrorView)? = nil
    ) {
        _imageLoader = StateObject(
            wrappedValue: ImageLoader(networkManager: NetworkManager.shared)
        )
        
        self.url = url
        self.placeholderWithProgress = placeholder
        self.image = image
        self.error = error
        
        self.placeholder = nil
    }
}

// MARK: - Ext. Configure views

extension CachedAsyncImage {
    @ViewBuilder
    private var content: some View {
        if let unifiedImage = imageLoader.image {
            image(Image(unifiedImage: unifiedImage))
        } else {
            errorOrPlaceholder
        }
    }
    
    @ViewBuilder
    private var errorOrPlaceholder: some View {
        if let error = error, let errorMessage = imageLoader.errorMessage {
            error(errorMessage)
        } else {
            if let placeholder = placeholder {
                placeholder()
            }
            
            if let placeholderWithProgress = placeholderWithProgress {
                let percentValue = Int((imageLoader.progress ?? .zero) * 100)
                let progress = String(percentValue)
                
                placeholderWithProgress(progress)
            }
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
                placeholder: { progress in
                    ZStack {
                        Color.yellow
                        
                        ProgressView() {
                            VStack {
                                Text("Downloading...")
                                Text("\(progress) %")
                            }
                        }
                    }
                },
                image: { image in
                    image
                        .resizable()
                        .scaledToFit()
                },
                error: { error in
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
                            .foregroundColor(.red)
                        }
                        .padding()
                    }
                }
            )
            
        }
    }
}
