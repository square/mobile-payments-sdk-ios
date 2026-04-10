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
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.5.0/SquareMobilePaymentsSDK_5b3a1df39f0a.zip",
            checksum: "109737f24088707bb4b7ede4d0281a912255b5fd2717291b85a06d505117d70f"
        ),
        .binaryTarget(
            name: "MockReaderUI",
            url: "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.5.0/MockReaderUI_5b3a1df39f0a.zip",
            checksum: "2136835f8f0a6cdd95c90ff85c50bfdf11ae3dd7f58a9361dc2c7691f0488e7a"
        ),
    ]
)
