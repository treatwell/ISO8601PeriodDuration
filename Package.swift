// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ISO8601PeriodDuration",
    products: [
        .library(
            name: "ISO8601PeriodDuration",
            targets: ["ISO8601PeriodDuration"]
        ),
    ],
    targets: [
        .target(
            name: "ISO8601PeriodDuration",
            dependencies: []
        ),
        .testTarget(
            name: "ISO8601PeriodDurationTests",
            dependencies: ["ISO8601PeriodDuration"]
        ),
    ]
)
