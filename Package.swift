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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.4/SquareMobilePaymentsSDK_85274b307ec5.zip",
            checksum: "1373892629028f17626b8f4c23c66f9f8b94f075e51bad3af1287dfd6a6a710f"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.4/MockReaderUI_85274b307ec5.zip",
            checksum: "3f117bf3ba83a7ef6680046e207f01779742cb6e9a12ba641347ed9c89cb2d0a"
        ),
    ]
)
