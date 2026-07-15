// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "airplane_mode_checker",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "airplane-mode-checker", targets: ["airplane_mode_checker"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "airplane_mode_checker",
            dependencies: [],
            resources: []
        )
    ]
)
