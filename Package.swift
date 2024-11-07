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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.0.1/SquareMobilePaymentsSDK_1320fafdc975.zip",
            checksum: "07da9a6a80dc73bed0bf89d5e014231c68e3abbf788e02772998bfeeed4cb89b"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.0.1/MockReaderUI_1320fafdc975.zip",
            checksum: "2ed1cd6b803e5693a7069592d9ec359779adb9c060983e95a8bb220bc8f0052b"
        ),
    ]
)
