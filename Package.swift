// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CachedAsyncImage",
    platforms: [
        // Add support for all platforms starting from a specific version.
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CachedAsyncImage",
            targets: ["CachedAsyncImage"]
        ),
        .library(
            name: "ExampleCachedAsyncImage",
            targets: ["Examples"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CachedAsyncImage"
        ),
        .target(
            name: "Examples",
            dependencies: ["CachedAsyncImage"],
            path: "Examples"
        ),
        .testTarget(
            name: "CachedAsyncImageTests",
            dependencies: ["CachedAsyncImage"]
        )
    ]
)
