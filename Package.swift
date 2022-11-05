// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwitchEvents",
    platforms: [.macOS(.v12),.iOS(.v15)],
    products: [
        .executable(
          name: "TwitchEventClient",
          targets: ["TwitchEventClient"]
        ),
        .library(
            name: "TwitchEvents",
            targets: ["TwitchEvents"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", exact: "0.0.3")
    ],
    targets: [
        .executableTarget(
            name: "TwitchEventClient",
            dependencies: ["TwitchEvents"]
        ),
        .target(
            name: "TwitchEvents",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]
        ),
        .testTarget(
            name: "TwitchEventsTests",
            dependencies: ["TwitchEvents"]
        ),
    ]
)
