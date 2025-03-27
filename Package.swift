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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.0/SquareMobilePaymentsSDK_6a7948b75cad.zip",
            checksum: "2eab7101463ed2103f82aa91bb856ba5a32c02096874175db3edd55f929170a9"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.0/MockReaderUI_6a7948b75cad.zip",
            checksum: "f1221c8ef7d2126b69d805c4479d842aa5e2d47693acc4cc56500a790b0565c6"
        ),
    ]
)
