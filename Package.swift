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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.0.0-beta3/SquareMobilePaymentsSDK_d86d59057def.zip",
            checksum: "bd00b517292828606b5c205100e245ee2154df1aa9947483d718990ed148cc8a"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.0.0-beta3/MockReaderUI_d86d59057def.zip",
            checksum: "2c3df818720cdd133f0c34ee7230b794a3692673f5e2e892fbbdcd5681bb91ef"
        ),
    ]
)
