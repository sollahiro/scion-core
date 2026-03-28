// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ScionCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "ScionCore",
            targets: ["ScionCore"]
        ),
    ],
    targets: [
        .target(
            name: "ScionCore",
            path: "Sources/ScionCore"
        ),
        .testTarget(
            name: "ScionCoreTests",
            dependencies: ["ScionCore"],
            path: "Tests/ScionCoreTests"
        ),
    ]
)
