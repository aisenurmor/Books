// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Feature",
            targets: ["Feature"]
        ),
    ],
    dependencies: [
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "Feature",
            dependencies: [
                "Home",
                "Search",
                "NetworkService"
            ]
        ),
        .target(
            name: "Home",
            dependencies: [
                .product(name: "Helper", package: "Core"),
                .product(name: "Model", package: "Core"),
                .product(name: "Navigation", package: "Core"),
                .product(name: "Repository", package: "Core"),
                
                "NetworkService"
            ]
        ),
        .target(
            name: "Search",
            dependencies: [
                .product(name: "Helper", package: "Core"),
                .product(name: "Model", package: "Core"),
                .product(name: "Navigation", package: "Core"),
                .product(name: "Repository", package: "Core")
            ]
        ),
        .target(
            name: "NetworkService",
            dependencies: [
                .product(name: "Model", package: "Core"),
                .product(name: "Network", package: "Core")
            ]
        ),
        .testTarget(
            name: "Tests",
            dependencies: []
        )
    ]
)
