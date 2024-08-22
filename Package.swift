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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.0.0-beta2/SquareMobilePaymentsSDK_b854a2f0e98b.zip",
            checksum: "0b7b6244183048b49cc8d392e6127bb5cf59bfc23de23b2715db7b51146fab15"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.0.0-beta2/MockReaderUI_b854a2f0e98b.zip",
            checksum: "4e22f18fe259e2e490d04f2c2e422415188469aae06185f6268dc9ded353707e"
        ),
    ]
)
