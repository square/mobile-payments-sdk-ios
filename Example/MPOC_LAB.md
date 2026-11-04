# AU lab build

This branch customizes the existing DonutCounter sample for a single-account AU lab build. It uses the released SDK binaries from the root `Package.swift`.

The home screen adds an AUD amount keypad, automatic/online/offline processing controls, payment results, and offline queue status. Permissions, reader settings, payment entry, and PIN screens come from the existing sample and SDK. The target excludes `MockReaderUI` for production distribution.

## Local configuration

Copy `Shared/MPoCLabCredentials.example.plist` to `Shared/MPoCLabCredentials.plist`. The destination is ignored by git. Set these values locally:

- `squareApplicationID`: the production Square application ID.
- `accessToken`: the access token authorized for the lab merchant.
- `locationID`: the AU location to authorize.
- `expectedLocationID`: the independently confirmed location for this lab build. The archive check requires it to match `locationID`.

The build bundles this local file so the lab can sign in through the existing Permissions screen. Keep actual credentials and the resulting app artifacts out of version control. This single-account credential setup is for the lab build; a production integration should obtain authorization through its backend.

The project uses the confirmed App Store Connect app **Donut Counter MPSDK Sample App** (Apple ID `6751421366`), bundle ID `com.squareup.mpsdk.DonutCounter`, and Block App Store team `EYF346PHUG`. Its App Store provisioning profile is named `Donut Counter`. Distribution still requires the matching signing identity and upload authentication. The archive phase rejects missing credentials, a non-production application ID, a location mismatch, or a skipped SDK setup script.

## Verification

Run the keypad's standalone unit tests from the repository root:

```sh
swift test --package-path Example/DonutCounter
```

Open `DonutCounter/DonutCounter.xcodeproj` to inspect the app in a simulator. Enter an amount, authorize through Permissions, and open Settings to inspect the SDK screens. The simulator can show account eligibility and queue status; reader PIN and offline capture/forwarding require a production AU device and compatible reader.

For device validation, install the distributed Release build, establish an online reader session, and test the following:

- Native PIN: use the agreed card and amount that request PIN verification. The app does not force a PIN prompt.
- Manual entry: select Online processing and use the SDK's manual card-entry option.
- Offline: confirm eligibility, select Offline processing, capture within the merchant limits, reconnect, and refresh the queue to inspect forwarding status.

Keep the app installed and authorized while offline payments remain pending. The SDK does not support offline keyed entry.
