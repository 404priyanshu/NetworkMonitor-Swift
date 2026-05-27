// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NetworkMonitor",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "NetworkMonitor", targets: ["NetworkMonitor"])
    ],
    targets: [
        .target(name: "NetworkMonitorCore"),
        .executableTarget(
            name: "NetworkMonitor",
            dependencies: ["NetworkMonitorCore"]
        ),
        .testTarget(
            name: "NetworkMonitorCoreTests",
            dependencies: ["NetworkMonitorCore"]
        )
    ]
)
