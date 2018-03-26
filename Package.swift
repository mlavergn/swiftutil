// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Util",
    products: [
        .library(
            name: "Util",
            targets: ["Util"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Util",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "UtilTests",
            dependencies: ["Util"],
            path: "Tests")
    ]
)
