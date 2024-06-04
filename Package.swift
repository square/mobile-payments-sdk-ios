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
            path: "XCFrameworks/SquareMobilePaymentsSDK_6432c60c8568.zip"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            path: "XCFrameworks/MockReaderUI_6432c60c8568.zip"
        ),
    ]
)