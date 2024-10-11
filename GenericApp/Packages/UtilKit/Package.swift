// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UtilKit",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UtilKit",
            targets: ["UtilKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", exact: "4.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UtilKit",
            dependencies: [
                "PhoneNumberKit"
            ]),
        .testTarget(
            name: "UtilKitTests",
            dependencies: ["UtilKit"]),
    ]
)
