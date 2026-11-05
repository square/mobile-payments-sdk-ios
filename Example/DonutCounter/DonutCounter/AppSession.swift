import Foundation
import Observation
import SquareMobilePaymentsSDK

/// The SDK's application ID is fixed for the process; seller authorization can change independently.
@MainActor @Observable final class AppSession: NSObject, AuthorizationStateObserver {
    private(set) var sdk: SDKManager?
    private(set) var activeApplicationID: String?
    private(set) var savedApplicationID: String
    private(set) var savedLocationID: String
    private(set) var authorizationState: AuthorizationState = .notAuthorized
    private(set) var isBusy = false
    private(set) var requiresRestart = false
    var errorMessage: String?
    var currency: TestCurrency {
        didSet { defaults.set(currency.rawValue, forKey: "testCurrency") }
    }

    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        savedApplicationID = defaults.string(forKey: "squareApplicationID") ?? ""
        savedLocationID = defaults.string(forKey: "squareLocationID") ?? ""
        currency = TestCurrency(rawValue: defaults.string(forKey: "testCurrency") ?? "")
            ?? TestCurrency(rawValue: Locale.current.currency?.identifier ?? "") ?? .USD
        super.init()
    }

    func initializeSavedApplication() {
        if sdk == nil, SignInConfiguration.isValidApplicationID(savedApplicationID) {
            initialize(applicationID: savedApplicationID)
        }
    }

    var locationCurrency: TestCurrency? {
        guard let code = sdk?.authorizationManager.location?.currency.currencyCode else { return nil }
        return TestCurrency(rawValue: code)
    }

    var currencyMatchesLocation: Bool { currency == locationCurrency }

    func signIn(_ configuration: SignInConfiguration) async {
        guard !isBusy, !requiresRestart, configuration.isValid else { return }
        isBusy = true
        errorMessage = nil
        defer { isBusy = false }

        if sdk == nil { initialize(applicationID: configuration.applicationID) }
        if let sdk, sdk.authorizationManager.state == .authorized {
            await deauthorize(sdk)
        }

        savedApplicationID = configuration.applicationID
        savedLocationID = configuration.locationID
        defaults.set(savedApplicationID, forKey: "squareApplicationID")
        defaults.set(savedLocationID, forKey: "squareLocationID")

        if let activeApplicationID, activeApplicationID != configuration.applicationID {
            // There is no public SDK reset. Persist only non-secret settings for the next launch.
            requiresRestart = true
            return
        }
        guard let sdk, sdk.authorizationManager.state == .notAuthorized else {
            errorMessage = NSLocalizedString("Unable to sign out of the previous account. Try again.", comment: "Account switch failure")
            return
        }

        let error: Error? = await withCheckedContinuation { continuation in
            sdk.authorizationManager.authorize(
                withAccessToken: configuration.accessToken,
                locationID: configuration.locationID
            ) { continuation.resume(returning: $0) }
        }
        authorizationState = sdk.authorizationManager.state
        if let error {
            errorMessage = configuration.failureMessage(for: error as NSError)
        }
    }

    func signOut() async {
        guard !isBusy, let sdk else { return }
        isBusy = true
        errorMessage = nil
        await deauthorize(sdk)
        isBusy = false
    }

    nonisolated func authorizationStateDidChange(_ state: AuthorizationState) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.authorizationState = self.sdk?.authorizationManager.state ?? .notAuthorized
        }
    }

    private func initialize(applicationID: String) {
        // First-run entry may happen after launch. Never access shared before this call or initialize twice.
        MobilePaymentsSDK.initialize(squareApplicationID: applicationID)
        activeApplicationID = applicationID
        sdk = MobilePaymentsSDK.shared
        sdk?.authorizationManager.add(self)
        authorizationState = sdk?.authorizationManager.state ?? .notAuthorized
    }

    private func deauthorize(_ sdk: SDKManager) async {
        await withCheckedContinuation { continuation in
            sdk.authorizationManager.deauthorize { continuation.resume() }
        }
        authorizationState = sdk.authorizationManager.state
    }
}

extension TestCurrency {
    var sdkCurrency: Currency {
        switch self {
        case .AUD: .AUD
        case .CAD: .CAD
        case .EUR: .EUR
        case .GBP: .GBP
        case .JPY: .JPY
        case .USD: .USD
        }
    }
}
