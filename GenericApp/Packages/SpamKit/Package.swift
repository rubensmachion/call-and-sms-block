// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpamKit",
    platforms: [ .iOS(.v16) ],
    products: [
        .library(
            name: "SpamKit",
            targets: ["SpamKit"]),
    ],
    dependencies: [
        .package(path: "../AppNavigationKit"),
        .package(path: "../UtilKit"),
    ],
    targets: [
        .target(
            name: "SpamKit",
            dependencies: [
                "AppNavigationKit",
                "UtilKit"
            ]),
        .testTarget(
            name: "SpamKitTests",
            dependencies: ["SpamKit"]),
    ]
)
