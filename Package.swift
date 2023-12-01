// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
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
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0")
    ],
    targets: [
        .macro(
            name: "ToolboxMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]),
        .target(
            name: "Toolbox",
            dependencies: ["ToolboxMacros"]),
        .testTarget(
            name: "ToolboxTests",
            dependencies: [
                "Toolbox",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]),
    ]
)
