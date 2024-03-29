//
//  ContentView.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI
import CachedAsyncImage

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
struct ContentView: View {
    // MARK: - Private Properties
    
    private let posters = [
        "https://image.tmdb.org/t/p/original/7lyBcpYB0Qt8gYhXYaEZUNlNQAv.jpg",
        "https://image.tmdb.org/t/p/original/ygGmAO60t8GyqUo9xYeYxSZAR3b.jpg",
        "https://image.tmdb.org/t/p/original/i0enkzsL5dPeneWnjl1fCWm6L7k.jpg",
        "https://image.tmdb.org/t/p/original/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg"
    ]
    
    private static let standartPadding: CGFloat = 20
    
    // MARK: - Initializers
    
    init() {
        // Set image cache limit.
        ImageCache().wrappedValue.setCacheLimit(
            countLimit: 1000, // 1000 items
            totalCostLimit: 1024 * 1024 * 200 // 200 MB
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color(RM.snow)
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                let size = geometry.size
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(posters, id: \.self) { url in
                            CachedAsyncImage(
                                url: url,
                                placeholder: { progress in
                                    // Create any view for placeholder (optional).
                                    placeholder(progress)
                                },
                                image: {
                                    // Customize image.
                                    Image(cpImage: $0)
                                        .resizable()
                                        .scaledToFill()
                                },
                                error: { error, retry in
                                    // Create any view for error (optional).
                                    self.error(error, action: retry)
                                }
                            )
                            .frame(
                                maxWidth: size.width - Self.standartPadding * 2,
                                idealHeight:
                                    getIdealHeight(
                                        geometrySize: size,
                                        aspectRatio: 2 / 3
                                    )
                            )
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding([.leading, .trailing], Self.standartPadding)
                        }
                    }
                    .padding([.top, .bottom], Self.standartPadding)
                }
            }
        }
        #if os(macOS)
        .frame(width: 300, height: 450)
        #endif
    }
    
    // MARK: - Private Methods
    
    private func getIdealHeight(
        geometrySize: CGSize,
        aspectRatio: CGFloat
    ) -> CGFloat {
        let width = geometrySize.width - Self.standartPadding * 2
        return width / aspectRatio
    }
}

// MARK: - Ext. Configure views

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
extension ContentView {
    func placeholder(_ progress: String) -> some View {
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
    
    func error(_ error: String, action: (() -> Void)? = nil) -> some View {
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
                .foregroundStyle(.red)
                
                retry(action: action)
                    .padding(.top)
            }
            .padding()
        }
    }
    
    func retry(action: (() -> Void)?) -> some View {
        Button(
            action: { action?() },
            label: {
                Text("Retry")
                    .foregroundStyle(.black)
                    .opacity(0.8)
            }
        )
    }
}

// MARK: - Preview Provider

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
