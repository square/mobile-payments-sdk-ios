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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.0.2/SquareMobilePaymentsSDK_f19bce61c9d1.zip",
            checksum: "b2809ceb46ce5252596eed8a103ba01436c6a0b016ffdddcce7859eb6ca2216b"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.0.2/MockReaderUI_f19bce61c9d1.zip",
            checksum: "4e517c6c27e97c740499fd9ef34fee188d78fb804f947eebed0ec90dd0c3e541"
        ),
    ]
)
