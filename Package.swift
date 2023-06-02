// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "SwiftSubRip",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "SwiftSubRip", targets: ["SwiftSubRip"]),
    ],
    targets: [
        .target(name: "SwiftSubRip",
                dependencies: []
               ),
        .testTarget(name: "SwiftSubRipTests",
                    dependencies: ["SwiftSubRip"],
                    resources: [.process("Resources")]
                   ),
    ]
)
