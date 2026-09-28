# AGENTS.md — Square Mobile Payments SDK for iOS

Guidance for coding agents **integrating the Mobile Payments SDK into an iOS app**.
This repo distributes the SDK as binary frameworks and ships the Donut Counter sample in `Example/`.

Current SDK version: **2.6.0**.

## Dependencies

Two products: `SquareMobilePaymentsSDK` (required) and `MockReaderUI` (Sandbox testing, debug only).

### Swift Package Manager

Package URL `https://github.com/square/mobile-payments-sdk-ios`, dependency rule **Exact Version `2.6.0`**. Add `SquareMobilePaymentsSDK` to your app target; add `MockReaderUI` too if you need mock readers.

### CocoaPods

```ruby
use_frameworks!

pod "SquareMobilePaymentsSDK", "~> 2.6.0"
pod "MockReaderUI", "~> 2.6.0", configurations: ['Debug']
```

`MockReaderUI` requires `SquareMobilePaymentsSDK` to be present as well.

See [Package.swift](Package.swift), [SquareMobilePaymentsSDK.podspec](SquareMobilePaymentsSDK.podspec).

## Build constraints

**The setup run script is mandatory.** Without it the framework is not usable at runtime. On the app target's **Build Phases** tab, add a **New Run Script Phase**, positioned *after* any `[CP] Embed Pods Frameworks` or `Embed Frameworks` phase:

```sh
SETUP_SCRIPT=${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}"/SquareMobilePaymentsSDK.framework/setup"
if [ -f "$SETUP_SCRIPT" ]; then
  "$SETUP_SCRIPT"
fi
```

This is the most commonly missed step. If the SDK misbehaves at launch in an otherwise correct integration, check for this phase and its ordering first.

**Deployment target.** The package and both podspecs declare a minimum of **iOS 16.0**. Square's documentation recommends 17.1 or later, and the sample app in this repo builds against 17.2. Below 16.0 the dependency will not resolve at all.

**Never ship `MockReaderUI` in a release build.** It is a debug/Sandbox tool. With CocoaPods, `configurations: ['Debug']` handles this. With SPM there is no Debug-only dependency, so you must remove the product from the target (or strip the framework) before archiving.

## Credentials

Three values, from the [Developer Console](https://developer.squareup.com/apps). Toggle **Sandbox** at the top of the Credentials page for test credentials.

| Value | Used by |
| :--- | :--- |
| Application ID | `MobilePaymentsSDK.initialize(squareApplicationID:)` |
| Access token | `authorizationManager.authorize(withAccessToken:locationID:)` |
| Location ID | same call — from the **Locations** page |

A Sandbox application ID puts the SDK in Sandbox mode; `settingsManager.sdkSettings.environment` reports it. Moving to production means re-initializing with the production application ID.

In this sample the values live in [Example/Shared/Config.swift](Example/Shared/Config.swift), all three declared `nil`. **Leave them `nil`** — never commit real credential values here or in the user's repo. Tell the user to fill them in locally. The sample deliberately `fatalError`s when they are still `nil`.

A personal access token is acceptable for Sandbox only. Production authorization must use OAuth, and a shipped app must not embed a personal access token.

## Privacy permissions

Required `Info.plist` keys — the SDK's reader features fail without them:

| Key | Purpose |
| :--- | :--- |
| `NSBluetoothAlwaysUsageDescription` | Connect and communicate with Square readers |
| `NSLocationWhenInUseUsageDescription` | Confirm where transactions take place |
| `NSMicrophoneUsageDescription` | Receive payment card data from magstripe readers |

If you support Square Stand or wired accessories, also declare `UISupportedExternalAccessoryProtocols` — see [Example/Shared/Info.plist](Example/Shared/Info.plist) for the protocol strings this sample uses.

Merchants in Canada, the UK, and the EU additionally require tracking-consent handling via `TrackingConsentManager`.

## Ordering rule

The order is not optional:

1. **Initialize** — `MobilePaymentsSDK.initialize(squareApplicationID:)` in `application(_:didFinishLaunchingWithOptions:)`.
2. **Request permissions** — Bluetooth, location, and microphone, before authorizing.
3. **Authorize** — `MobilePaymentsSDK.shared.authorizationManager.authorize(withAccessToken:locationID:)`.
4. Only then use `paymentManager`, `readerManager`, or `settingsManager`.

Any manager call made before authorization completes fails with **`NOT_AUTHORIZED`**. If you see that error code, the fix is ordering, not parameters.

```swift
// 1. AppDelegate
MobilePaymentsSDK.initialize(squareApplicationID: applicationId)

// 3. after permissions are granted
guard MobilePaymentsSDK.shared.authorizationManager.state == .notAuthorized else { return }
MobilePaymentsSDK.shared.authorizationManager.authorize(
    withAccessToken: accessToken,
    locationID: locationID
) { error in
    if let error { print("Failed to authorize: \(error)") }
}
```

Guarding on `state == .notAuthorized` matters: authorizing while already authorized returns an `ALREADY_AUTHORIZED` error.

See [DonutCounterApp.swift](Example/DonutCounter/DonutCounter/DonutCounterApp.swift) and [PermissionsView.swift](Example/DonutCounter/DonutCounter/Screens/Permissions/PermissionsView.swift).

## Taking a payment

```swift
let paymentParameters = PaymentParameters(
    paymentAttemptID: paymentAttemptID,
    amountMoney: Money(amount: 100, currency: .USD),
    processingMode: .autoDetect
)
let promptParameters = PromptParameters(mode: .default, additionalMethods: .all)

MobilePaymentsSDK.shared.paymentManager.startPayment(
    paymentParameters,
    promptParameters: promptParameters,
    from: viewController,
    delegate: self
)
```

Two things the sample calls out explicitly:

- `paymentAttemptID` must be derived from an order/sale identifier in a real integration, not a fresh `UUID()` per tap — that is what protects against duplicate payments on retry.
- **Sandbox supports only `.onlineOnly` processing.** Use `.autoDetect` in production and `.onlineOnly` in Sandbox; the sample branches on `settingsManager.sdkSettings.environment` to do exactly this. See [HomeView.swift](Example/DonutCounter/DonutCounter/Screens/Home/HomeView.swift).

## Testing with mock readers in Sandbox

Physical Square readers do **not** work in Sandbox. Virtual readers come from the `MockReaderUI` framework.

```swift
#if canImport(MockReaderUI)
let mockReader = try MockReaderUI(for: MobilePaymentsSDK.shared)
try mockReader.present()
// …
mockReader.dismiss()
#endif
```

**Known limitation — read this before planning an automated test.** The published framework exposes only instantiation, `present()`, and `dismiss()`. There is no public API to add a mock reader, select a card brand, or simulate a tap/insert/swipe. Those steps happen only through the floating button the SDK draws over your app, and require a human:

> tap the floater → add a magstripe or contactless & chip reader → start the payment → tap the floater → tap/insert/swipe a card

So an agent **cannot** drive an end-to-end Sandbox payment on its own. If a task requires one, say so and ask the user to perform the taps — do not sit waiting on a payment delegate callback that will never fire.

Also: after testing an inserted card, remove it through the mock reader UI before starting the next payment.

## Documentation

Fetch the `.md` variants. The HTML pages are iframe shells and return only navigation chrome to a programmatic fetch.

- Overview — https://developer.squareup.com/docs/mobile-payments-sdk.md
- Build on iOS — https://developer.squareup.com/docs/mobile-payments-sdk/ios.md
- Authorize — https://developer.squareup.com/docs/mobile-payments-sdk/ios/configure-authorize.md
- Pair and manage readers — https://developer.squareup.com/docs/mobile-payments-sdk/ios/pair-manage-readers.md
- Take payments — https://developer.squareup.com/docs/mobile-payments-sdk/ios/take-payments.md
- Handling errors — https://developer.squareup.com/docs/mobile-payments-sdk/ios/handling-errors.md
- API reference — https://developer.squareup.com/docs/sdk/mobile-payments/ios

DocC archives for both frameworks ship in [Docs/MobilePaymentsSDK_DocC.zip](Docs/MobilePaymentsSDK_DocC.zip); unzip and open the `.doccarchive` files in Xcode.

## Repo layout

```
Package.swift                   SPM binary targets, iOS 16.0 platform, version pins
SquareMobilePaymentsSDK.podspec / MockReaderUI.podspec
Docs/                           DocC archives
Example/
  Shared/Config.swift           credential placeholders (all nil)
  Shared/Info.plist             external accessory protocols
  DonutCounter/DonutCounter/
    DonutCounterApp.swift       initialize()
    Screens/Permissions/        permissions + authorize()
    Screens/Home/HomeView.swift startPayment(), settings, MockReaderUI
```

Running the sample: fill in `Example/Shared/Config.swift`, open `Example/DonutCounter/DonutCounter.xcodeproj`, select the `DonutCounter` target, run.
