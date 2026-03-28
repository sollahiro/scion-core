// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CypraeaCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "CypraeaCore",
            targets: ["CypraeaCore"]
        ),
    ],
    targets: [
        .target(
            name: "CypraeaCore",
            path: "Sources/CypraeaCore"
        ),
        .testTarget(
            name: "CypraeaCoreTests",
            dependencies: ["CypraeaCore"],
            path: "Tests/CypraeaCoreTests"
        ),
    ]
)
