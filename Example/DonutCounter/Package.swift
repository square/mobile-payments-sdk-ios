// swift-tools-version: 6.0
import PackageDescription

// The keypad's money handling can be tested without initializing the payment SDK or signing an app.
let package = Package(
    name: "DonutCounterAmount",
    platforms: [.macOS(.v13)],
    targets: [
        .target(
            name: "DonutCounterAmount",
            path: "DonutCounter/Components",
            exclude: ["AppButtons.swift", "MobilePaymentsSDKViewHolder.swift", "MoneyKeypadView.swift"],
            sources: ["MoneyAmountEntry.swift"]
        ),
        .testTarget(name: "DonutCounterAmountTests", dependencies: ["DonutCounterAmount"], path: "Tests"),
    ]
)
