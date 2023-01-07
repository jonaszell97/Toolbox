// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Toolbox",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "Toolbox",
            targets: ["Toolbox"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Toolbox",
            dependencies: []),
        .testTarget(
            name: "ToolboxTests",
            dependencies: ["Toolbox"]),
    ]
)
