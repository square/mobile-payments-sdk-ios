import Foundation

enum TestCurrency: String, CaseIterable, Identifiable {
    case AUD, CAD, EUR, GBP, JPY, USD

    var id: Self { self }

    var title: String {
        let name = Locale.current.localizedString(forCurrencyCode: rawValue) ?? rawValue
        return "\(rawValue) — \(name)"
    }
}

struct SignInConfiguration {
    let applicationID: String
    let accessToken: String
    let locationID: String

    init(applicationID: String, accessToken: String, locationID: String) {
        self.applicationID = applicationID.trimmingCharacters(in: .whitespacesAndNewlines)
        self.accessToken = accessToken.trimmingCharacters(in: .whitespacesAndNewlines)
        self.locationID = locationID.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func isValidApplicationID(_ value: String) -> Bool {
        ["sq0idp-", "sandbox-sq0idb-"].contains { value.hasPrefix($0) && value.count > $0.count }
    }

    var isValid: Bool {
        Self.isValidApplicationID(applicationID) && !accessToken.isEmpty && !locationID.isEmpty
    }

    func failureMessage(for error: NSError) -> String {
        let message = error.userInfo["com.squareup.MobilePaymentsSDK.ErrorDebugMessage"] as? String ?? error.localizedDescription
        let code = error.userInfo["com.squareup.MobilePaymentsSDK.ErrorDebugCode"] as? String ?? "\(error.domain) (\(error.code))"
        var detail = "\(message)\n\(code)"
        for value in [accessToken, applicationID, locationID] where !value.isEmpty {
            detail = detail.replacingOccurrences(of: value, with: "[hidden]")
        }
        return String(format: NSLocalizedString("Sign-in failed: %@", comment: "SDK authorization error with submitted credentials redacted"), detail)
    }
}
