import SwiftUI
import SquareMobilePaymentsSDK

struct AccountView: View {
    @Bindable var session: AppSession
    @State private var permissions = PermissionsViewModel()
    @State private var applicationID: String
    @State private var accessToken = ""
    @State private var locationID: String
    @SwiftUI.Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    var canDismiss = false

    private enum Field { case applicationID, accessToken, locationID }

    init(session: AppSession, canDismiss: Bool = false) {
        self.session = session
        self.canDismiss = canDismiss
        _applicationID = State(initialValue: session.savedApplicationID)
        _locationID = State(initialValue: session.savedLocationID)
    }

    private var configuration: SignInConfiguration {
        SignInConfiguration(applicationID: applicationID, accessToken: accessToken, locationID: locationID)
    }

    var body: some View {
        NavigationStack {
            Form {
                if session.requiresRestart {
                    Section {
                        Label(NSLocalizedString("Reopen DonutCounter", comment: "Application ID change requires relaunch"), systemImage: "arrow.clockwise")
                            .font(.headline)
                        Text(NSLocalizedString("Close DonutCounter from the app switcher and open it again to use the new application ID. Then enter your access token to sign in.", comment: "SDK application ID can only change after process relaunch"))
                    }
                }

                Section {
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("Application ID", comment: "Square application identifier")).font(.caption).foregroundStyle(.secondary)
                        TextField("sq0idp-…", text: $applicationID)
                            .accessibilityLabel(Text(NSLocalizedString("Application ID", comment: "Square application identifier")))
                            .accessibilityIdentifier("applicationID")
                            .focused($focusedField, equals: .applicationID)
                    }
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("Access token", comment: "Square authorization token")).font(.caption).foregroundStyle(.secondary)
                        SecureField(NSLocalizedString("Enter access token", comment: "Access token field placeholder"), text: $accessToken)
                            .privacySensitive()
                            .accessibilityLabel(Text(NSLocalizedString("Access token", comment: "Square authorization token")))
                            .accessibilityIdentifier("accessToken")
                            .focused($focusedField, equals: .accessToken)
                    }
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("Location ID", comment: "Square location identifier")).font(.caption).foregroundStyle(.secondary)
                        TextField(NSLocalizedString("Enter location ID", comment: "Location field placeholder"), text: $locationID)
                            .accessibilityLabel(Text(NSLocalizedString("Location ID", comment: "Square location identifier")))
                            .accessibilityIdentifier("locationID")
                            .focused($focusedField, equals: .locationID)
                    }
                } header: {
                    Text(NSLocalizedString("Square credentials", comment: "Account credential section"))
                } footer: {
                    Text(NSLocalizedString("Use an access token issued for this application and location. Changing the application ID requires closing and reopening the app.", comment: "Credential requirements and SDK relaunch constraint"))
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .disabled(session.isBusy || session.requiresRestart)

                Section {
                    Picker(NSLocalizedString("Currency", comment: "Currency for test payments"), selection: $session.currency) {
                        ForEach(TestCurrency.allCases) { currency in
                            Text(currency.title).tag(currency)
                        }
                    }
                } footer: {
                    Text(NSLocalizedString("Payment currency must match the Square location. Changing currency does not convert an amount.", comment: "Location currency requirement"))
                }

                Section(NSLocalizedString("Permissions", comment: "Required device permissions")) {
                    PermissionsRow(title: String.Permissions.Bluetooth.bluetoothPermissionTitle,
                                   description: String.Permissions.Bluetooth.bluetoothPermissionDescription,
                                   isPermissionGranted: permissions.isBluetoothPermissionGranted) { permissions.requestBluetooth() }
                    PermissionsRow(title: String.Permissions.Location.locationPermissionTitle,
                                   description: String.Permissions.Location.locationPermissionDescription,
                                   isPermissionGranted: permissions.isLocationPermissionGranted) { permissions.requestLocation() }
                    PermissionsRow(title: String.Permissions.Microphone.microphonePermissionTitle,
                                   description: String.Permissions.Microphone.microphonePermissionDescription,
                                   isPermissionGranted: permissions.isMicrophonePermissionGranted) { permissions.requestMicrophone() }
                }

                Section {
                    Button {
                        let submitted = configuration
                        focusedField = nil
                        Task {
                            await session.signIn(submitted)
                            if session.authorizationState == .authorized || session.requiresRestart { accessToken = "" }
                        }
                    } label: {
                        if session.isBusy {
                            ProgressView().accessibilityLabel(Text(NSLocalizedString("Updating account", comment: "Account change progress")))
                        }
                        else { Text(NSLocalizedString("Sign in", comment: "Authorize the payment SDK with entered credentials")) }
                    }
                    .accessibilityIdentifier("signIn")
                    .disabled(!configuration.isValid || !permissions.allPermissionsGranted || session.isBusy || session.requiresRestart)

                    if session.authorizationState == .authorized {
                        Button(NSLocalizedString("Sign out", comment: "Sign out of the current Square account"), role: .destructive) {
                            accessToken = ""
                            Task { await session.signOut() }
                        }
                        .disabled(session.isBusy)
                    }
                    if let message = session.errorMessage {
                        Text(message).foregroundStyle(.red)
                            .accessibilityIdentifier("signInError")
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Square account", comment: "Sign-in screen title"))
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(NSLocalizedString("Done", comment: "Dismiss keyboard")) { focusedField = nil }
                }
                if canDismiss && !session.requiresRestart {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(NSLocalizedString("Done", comment: "Dismiss account settings")) { dismiss() }
                            .disabled(session.isBusy)
                    }
                }
            }
            .onAppear { permissions.refreshAllPermissionsStatus() }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                permissions.refreshAllPermissionsStatus()
            }
            .onChange(of: session.errorMessage) { _, message in
                if let message { UIAccessibility.post(notification: .announcement, argument: message) }
            }
            .onChange(of: session.savedApplicationID) { _, value in
                if session.isBusy { applicationID = value }
            }
            .onChange(of: session.savedLocationID) { _, value in
                if session.isBusy { locationID = value }
            }
            .interactiveDismissDisabled(session.isBusy || session.requiresRestart)
        }
    }
}
