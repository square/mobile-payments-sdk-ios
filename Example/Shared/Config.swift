import Foundation

public enum Config {
    private static let labCredentials: [String: String] = {
        guard let url = Bundle.main.url(forResource: "MPoCLabCredentials", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let values = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String]
        else { return [:] }
        return values.filter { !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }()

    static let squareApplicationID: String? = labCredentials["squareApplicationID"]

    // The lab's single-account build must authorize without a separate login service.
    // Keep these credentials in the ignored local plist rather than in version control.
    static let accessToken: String? = labCredentials["accessToken"]
    static let locationID: String? = labCredentials["locationID"]
}
