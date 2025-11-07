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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.3.1/SquareMobilePaymentsSDK_5bed59742985.zip",
            checksum: "299b6833fff59d77cb1659ca2c7199ff0f5b894c6ee38d66a2deaa63a5683533"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.3.1/MockReaderUI_5bed59742985.zip",
            checksum: "51ce29e4aac0c98ad2d43c4257572e34f3c4c21add80bfd929ddbd329eb18e8f"
        ),
    ]
)
