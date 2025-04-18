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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.2/SquareMobilePaymentsSDK_a9f319cf72cb.zip",
            checksum: "2ddb9db2a070ec2923376b8eb58d9b1cac833a4204edece87d9b2dbf595dcb70"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.2/MockReaderUI_a9f319cf72cb.zip",
            checksum: "20e6b6d7c30d6af519378405e41a219f3ffe4422b5da19f6bda05b7833ab2743"
        ),
    ]
)
