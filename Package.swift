// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.8.1")
    ],
    targets: [
        .target(
            name: "UIComponents",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher")
            ]
        )
    ]
)
