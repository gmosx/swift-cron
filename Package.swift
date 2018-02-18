// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Cron",
    products: [
        .library(name: "Cron", targets: ["Cron"])
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/LoggerAPI.git", from: "1.0.0"),
        .package(url: "https://github.com/reizu/Swift-Common.git", from: "0.0.0"),
    ],
    targets: [
        .target(
            name: "Cron",
            dependencies: [
                "LoggerAPI",
                "Common",
            ]
        ),
        .testTarget(name: "CronTests", dependencies: ["Cron"])
    ]
)
