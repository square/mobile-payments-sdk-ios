// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SquareMobilePaymentsSDK",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .library(name: "SquareMobilePaymentsSDK", targets: ["SquareMobilePaymentsSDK"]),
        .library(name: "MockReaderUI", targets: ["MockReaderUI"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "SquareMobilePaymentsSDK",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.4.0/SquareMobilePaymentsSDK_59854a3d09f8.zip",
            checksum: "ad516f40a8230a2de3e8a46ec46b45ed5df7bfa6fcf729e4f18b75f538b2abd1"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.4.0/MockReaderUI_59854a3d09f8.zip",
            checksum: "5ff1347a2f39c27367047f7328328db290f68a0f5723625c63d2167da44835b0"
        ),
    ]
)
