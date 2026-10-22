// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BunnyCore",
    platforms: [.iOS(.v17), .watchOS(.v10)],
    products: [.library(name: "BunnyCore", targets: ["BunnyCore"])],
    targets: [
        .target(name: "BunnyCore"),
        .testTarget(name: "BunnyCoreTests", dependencies: ["BunnyCore"])
    ]
)
