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
            path: "XCFrameworks/SquareMobilePaymentsSDK_bad_commit.zip"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            path: "XCFrameworks/MockReaderUI_bad_commit.zip"
        ),
    ]
)
