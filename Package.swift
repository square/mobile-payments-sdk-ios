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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.3/SquareMobilePaymentsSDK_56ca6e860134.zip",
            checksum: "b14003b21748b25118443455dcc34335fc75da11bbc7b373480cb72225306c90"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.3/MockReaderUI_56ca6e860134.zip",
            checksum: "b22d30e5b01342d86b906ef9a93fad98d06b9bc78bedfafd37ed19a807553176"
        ),
    ]
)
