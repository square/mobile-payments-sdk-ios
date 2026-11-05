# DonutCounter test app

Open `DonutCounter.xcodeproj` and run the DonutCounter scheme. The app uses the released Mobile Payments SDK binaries from the repository's Swift package.

On first launch, enter a Square application ID, an access token issued for that application, and a location ID. Grant Bluetooth, location, and microphone permissions, then tap **Sign in**. Production integrations should obtain seller access tokens through OAuth.

The app saves the application ID, location ID, and selected currency on the device. It does not save another copy of the access token entered into the form; the SDK manages its own persisted authorization session. Use **Account** to sign out or enter another account's credentials. Changing the application ID requires closing the app from the app switcher and reopening it, because the SDK initializes once per process. Enter the access token again after reopening.

Choose AUD, CAD, EUR, GBP, JPY, or USD. The selected currency must match the authorized Square location to enable payments. Selecting a different currency clears the entered amount; this is not currency conversion. The keypad uses the currency's minor-unit precision, including whole-unit JPY amounts.

No merchant credentials are included in the app bundle. The prepare phase removes a resource left by older single-account builds and prevents skipping the required SDK setup phase for archives. Keep the released SDK setup phase enabled for device builds. MockReaderUI is not linked into this test build.

The shared Info.plist declares `ITSAppUsesNonExemptEncryption = false` for this test build. This is the declaration that encryption is exempt from export-compliance documentation, not a claim that the SDK performs no encryption.

Run the independent credential-validation and amount tests with:

```sh
swift test --package-path Example/DonutCounter
```
