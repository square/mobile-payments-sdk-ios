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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.6.0/SquareMobilePaymentsSDK_ea5acbd68dbc.zip",
            checksum: "d4b654a7929229575bcc1a6bbd416404f867093e9a80288e556db85ee6abf106"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.6.0/MockReaderUI_ea5acbd68dbc.zip",
            checksum: "77ed59cdcbc3ae83c64160ef7875388bd26a7e0804bd8fcb76462c0713e19ffe"
        ),
    ]
)
