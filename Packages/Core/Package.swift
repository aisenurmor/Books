// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Configuration",
            targets: ["Configuration"]
        ),
        .library(
            name: "Helper",
            targets: ["Helper"]
        ),
        .library(
            name: "Model",
            targets: ["Model"]
        ),
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        ),
        .library(
            name: "Network",
            targets: ["Network"]
        ),
        .library(
            name: "Repository",
            targets: ["Repository"]
        ),
        .library(
            name: "Storage",
            targets: ["Storage"]
        ),
    ],
    targets: [
        .target(
            name: "Configuration"
        ),
        .target(
            name: "Helper"
        ),
        .target(
            name: "Model",
            dependencies: ["Helper"]
        ),
        .target(
            name: "Navigation",
            dependencies: ["Model"]
        ),
        .target(
            name: "Network",
            dependencies: ["Configuration"]
        ),
        .target(
            name: "Repository",
            dependencies: [
                "Storage",
                "Model",
            ]
        ),
        .target(
            name: "Storage"
        )
    ]
)
