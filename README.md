[![CocoaPods](https://img.shields.io/cocoapods/v/SquareMobilePaymentsSDK)](https://github.com/CocoaPods/CocoaPods)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)

# Square Mobile Payments SDK

Build remarkable in-person experiences using Square's Mobile Payments SDK product now in beta. The Mobile Payments SDK has the advantage of being an API driven framework that allows for full customization as well as using the latest [V2/Payments](https://developer.squareup.com/explorer/square/payments-api/list-payments) API.


## Installation

### Swift Package Manager

To install the `SquareMobilePaymentsSDK` into your Xcode project, follow these steps:

1. Select `File > Add Package Dependencies...`.
2. Enter the repository URL: `https://github.com/square/mobile-payments-sdk-ios`.
3. Select the `Exact Version` dependency rule and specify the version as `2.0.0-beta1`.
4. Ensure the `SquareMobilePaymentsSDK` product is added to your target.

Optionally, you can also add the `MockReaderUI` product to your target to simulate a physical reader when one is not present in a sandbox environment.

> [!WARNING]  
> Please note that the `MockReaderUI` product should only be used in debug configurations and is not to be included in the release version of your application.

### Cocoapods

Install with [CocoaPods](http://cocoapods.org/) by adding the following to your Podfile:

```
use_frameworks!

pod "SquareMobilePaymentsSDK", "~> 2.0.0.beta1"

# Optionally include MockReaderUI if you wish to simulate a physical reader when one is not present.
# This feature is only available when provided a sandbox application id.
pod "MockReaderUI", "~> 2.0.0.beta1", configurations: ['Debug']
```
_Note that MockReaderUI framework **requires** that `SquareMobilePaymentsSDK` framework to also be present in podfile_

#### Add build phase to setup the SquareMobilePaymentsSDK framework ####

On your application targets’ Build Phases settings tab, click the + icon and choose New Run Script Phase. Create a Run Script in which you specify your shell (ex: /bin/sh), add the following contents to the script area below the shell:
```
SETUP_SCRIPT=${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}"/SquareMobilePaymentsSDK.framework/setup"
if [ -f "$SETUP_SCRIPT" ]; then
  "$SETUP_SCRIPT"
fi
```

## Documentation Links
* [MobilePaymentsSDK Overview](https://developer.squareup.com/docs/mobile-payments-sdk)
* iOS Tech Reference
	* [MobilePaymentsSDK Framework](https://developer.squareup.com/docs/sdk/mobile-payments/ios)

If you need more assistance, contact [Developer and App Marketplace Support](https://squareup.com/help/us/en/contact?panel=BF53A9C8EF68) or ask for help in the [Developer Forums](https://developer.squareup.com/forums/).

