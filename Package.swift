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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.1.0/SquareMobilePaymentsSDK_efd25e90a0d6.zip",
            checksum: "43dc8249614941ba021437d1a4d2de1c8754d83ed44069492c02ef52d266d290"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.1.0/MockReaderUI_efd25e90a0d6.zip",
            checksum: "910834292407a04b81911cb969a8f187f5f8c2d35b7302c1dd4de74f4d9eb8db"
        ),
    ]
)
