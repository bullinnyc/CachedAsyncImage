//
//  CachedAsyncImage.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

/// Refreshable protocol.
public protocol Refreshable {
    /// Retry load the image.
    func refresh()
}

/// CachedAsyncImage view.
public struct CachedAsyncImage: View {
    // MARK: - Property Wrappers
    
    @StateObject private var imageLoader: ImageLoader
    
    // MARK: - Private Properties
    
    private let url: String
    private let placeholder: ((String) -> any View)?
    private let image: (CPImage) -> any View
    private let error: ((String, Refreshable) -> any View)?
    
    // MARK: - Initializers
    
    /// - Parameters:
    ///   - url: The URL for which to create a image.
    ///   - placeholder: Placeholder with progress to be displayed.
    ///   - image: Image to be displayed.
    ///   - error: Error with retry action to be displayed.
    public init(
        url: String,
        placeholder: ((String) -> any View)? = nil,
        image: @escaping (CPImage) -> any View,
        error: ((String, Refreshable) -> any View)? = nil
    ) {
        _imageLoader = StateObject(
            wrappedValue: ImageLoader(
                imageCache: ImageCache().wrappedValue,
                networkManager: Network().wrappedValue
            )
        )
        
        self.url = url
        self.placeholder = placeholder
        self.image = image
        self.error = error
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            switch imageLoader.state {
            case .idle:
                Color.clear
                    .onAppear {
                        imageLoader.fetchImage(from: url)
                    }
            case .loading(let progress):
                if let placeholder = placeholder {
                    let percentValue = Int(progress * 100)
                    let progress = String(percentValue)
                    
                    AnyView(placeholder(progress))
                }
            case .failed(let errorMessage):
                if let error = error {
                    AnyView(error(errorMessage, self))
                }
            case .loaded(let image):
                AnyView(self.image(image))
            }
        }
        .onChange(of: url) { newValue in
            imageLoader.fetchImage(from: newValue)
        }
    }
}

// MARK: - Ext. Refreshable

extension CachedAsyncImage: Refreshable {
    public func refresh() {
        imageLoader.fetchImage(from: url)
    }
}

// MARK: - Preview Provider

struct CachedAsyncImage_Previews: PreviewProvider {
    static func placeholder(_ progress: String) -> some View {
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
    
    static func error(
        _ error: String,
        action: (() -> Void)? = nil
    ) -> some View {
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
                
                retry(action: action)
                    .padding(.top)
            }
            .padding()
        }
    }
    
    static func retry(action: (() -> Void)?) -> some View {
        Button(
            action: { action?() },
            label: {
                Image(systemName: "arrow.circlepath")
                    .resizable()
                    .frame(width: 40, height: 36)
                    .opacity(0.6)
            }
        )
        .buttonStyle(.plain)
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
                placeholder: { progress in
                    placeholder(progress)
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
                error: { error, retry in
                    self.error(error, action: retry.refresh)
                }
            )
            
            CachedAsyncImage(
                url: url,
                placeholder: { progress in
                    placeholder(progress)
                },
                image: {
                    image($0)
                },
                error: { error, retry in
                    self.error(error, action: retry.refresh)
                }
            )
        }
        #if os(macOS)
        .frame(width: 300, height: 450)
        #endif
    }
}
