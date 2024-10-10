// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppNavigationKit",
    platforms: [ .iOS(.v16) ],
    products: [
        .library(
            name: "AppNavigationKit",
            targets: ["AppNavigationKit"]),
    ],
    targets: [
        .target(
            name: "AppNavigationKit"),
        .testTarget(
            name: "AppNavigationKitTests",
            dependencies: ["AppNavigationKit"]),
    ]
)
