// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-log-sentry",
    platforms: [.iOS(.v11), .macOS(.v10_13), .tvOS(.v11), .watchOS(.v4)],
    products: [
        .library(
            name: "LoggingSentry",
            targets: ["LoggingSentry"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.3"),
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.55.0"),
    ],
    targets: [
        .target(
            name: "LoggingSentry",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sentry", package: "sentry-cocoa"),
            ]
        ),
        .testTarget(
            name: "LoggingSentryTests",
            dependencies: [
                "LoggingSentry",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sentry", package: "sentry-cocoa"),
            ]
        ),
    ]
)
