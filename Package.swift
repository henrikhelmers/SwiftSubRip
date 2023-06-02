// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "swift-subrip",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "swift-subrip", targets: ["swift-subrip"]),
    ],
    targets: [
        .target(name: "swift-subrip",
                dependencies: []
               ),
        .testTarget(name: "swift-subripTests",
                    dependencies: ["swift-subrip"],
                    resources: [.process("Resources")]
                   ),
    ]
)
