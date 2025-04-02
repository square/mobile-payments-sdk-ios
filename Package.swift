// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SquareMobilePaymentsSDK",
    products: [
        .library(name: "SquareMobilePaymentsSDK", targets: ["SquareMobilePaymentsSDK"]),
        .library(name: "MockReaderUI", targets: ["MockReaderUI"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "SquareMobilePaymentsSDK",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.1/SquareMobilePaymentsSDK_d62eea75f1c0.zip",
            checksum: "130ea78786f74f26262679f9d484856918a88f7a9333a4c16bd185b4f6a55777"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.1/MockReaderUI_d62eea75f1c0.zip",
            checksum: "67f8c9168da4f6d0a3c8539a46049140a9e21e31b03c3ce511125a573e3d46fe"
        ),
    ]
)
