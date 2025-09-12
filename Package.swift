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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.3.0/SquareMobilePaymentsSDK_613d0ded3e6c.zip",
            checksum: "80c2b90c2be735142ada5a92507206ad5afb6f0a7702a5943957bb5e75935105"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.3.0/MockReaderUI_613d0ded3e6c.zip",
            checksum: "18a553b4adbf69622fc32e37ee0ba668bb7b14f2a5f81555429497e5c333b14a"
        ),
    ]
)
