// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HouseDataScript",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(
            name: "HouseDataScript",
            targets: ["Run"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kevcodex/ScriptHelpers", from: "1.0.0"),
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.0.0"),
        .package(url: "https://github.com/kevcodex/MiniNe", from: "3.0.0")
    ],
    targets: [
        .target(name: "Run", dependencies: ["Source"]),
        .target(name: "Source", dependencies: ["ScriptHelpers", "MiniNe", "Kanna"]),
        .testTarget(name: "SourceTests", dependencies: ["Source"])
    ]
)
