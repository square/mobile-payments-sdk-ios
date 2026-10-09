// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SquareMobilePaymentsSDK",
    platforms: [
        .iOS("17.1")
    ],
    products: [
        .library(name: "SquareMobilePaymentsSDK", targets: ["SquareMobilePaymentsSDK"]),
        .library(name: "MockReaderUI", targets: ["MockReaderUI"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "SquareMobilePaymentsSDK",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.7.0/SquareMobilePaymentsSDK_acc3b681b19a.zip",
            checksum: "637141b59b3e98a0ee0b0eeaf0bbc784dc79813be56e07b07ca1bf4b9c889599"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.7.0/MockReaderUI_acc3b681b19a.zip",
            checksum: "ab86ff7e93eb1da1ba4c5aed4f217f6c358239de57f6c98745c40b448ecbc344"
        ),
    ]
)
