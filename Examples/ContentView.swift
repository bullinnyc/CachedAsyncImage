//
//  ContentView.swift
//  CachedAsyncImage
//
//  Created by Dmitry Kononchuk on 15.06.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI
import CachedAsyncImage

@available(iOS 15.0, macOS 12.0, *)
struct ContentView: View {
    // MARK: - Private Properties
    
    private let posters = [
        "https://image.tmdb.org/t/p/original/7lyBcpYB0Qt8gYhXYaEZUNlNQAv.jpg",
        "https://image.tmdb.org/t/p/original/ygGmAO60t8GyqUo9xYeYxSZAR3b.jpg",
        "https://image.tmdb.org/t/p/original/i0enkzsL5dPeneWnjl1fCWm6L7k.jpg",
        "https://image.tmdb.org/t/p/original/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg"
    ]
    
    private static let paddingStandart: CGFloat = 20
    
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
                                image: {
                                    // Customize image.
                                    Image(cpImage: $0)
                                        .resizable()
                                        .scaledToFill()
                                },
                                error: { error in
                                    // Create any view for error (optional).
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
                                        }
                                        .padding()
                                    }
                                }
                            )
                            .frame(
                                maxWidth: size.width - Self.paddingStandart * 2,
                                idealHeight:
                                    getIdealHeight(
                                        geometrySize: size,
                                        aspectRatio: 2 / 3
                                    )
                            )
                            .clipped()
                            .cornerRadius(20)
                            .padding([.leading, .trailing], Self.paddingStandart)
                        }
                    }
                    .padding([.top, .bottom], Self.paddingStandart)
                }
            }
        }
        #if os(macOS)
        .frame(width: 300, height: 450)
        #endif
    }
    
    // MARK: - Initializers
    
    init() {
        // Set image cache limit.
        TemporaryImageCache.shared.setCacheLimit(
            countLimit: 1000, // 1000 items
            totalCostLimit: 1024 * 1024 * 200 // 200 MB
        )
    }
    
    // MARK: - Private Methods
    
    private func getIdealHeight(
        geometrySize: CGSize,
        aspectRatio: CGFloat
    ) -> CGFloat {
        let width = geometrySize.width - Self.paddingStandart * 2
        return width / aspectRatio
    }
}

// MARK: - Preview Provider

@available(iOS 15.0, macOS 12.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
