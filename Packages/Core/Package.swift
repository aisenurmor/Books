// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Configuration",
            targets: ["Configuration"]),
        .library(
            name: "Model",
            targets: ["Model"]),
        .library(
            name: "Network",
            targets: ["Network"]),
    ],
    targets: [
        .target(
            name: "Configuration",
            dependencies: []
        ),
        .target(
            name: "Model",
            dependencies: []
        ),
        .target(
            name: "Network",
            dependencies: ["Configuration"]
        )
    ]
)
