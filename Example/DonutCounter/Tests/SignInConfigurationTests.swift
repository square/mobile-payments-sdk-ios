import Foundation
import Testing
@testable import DonutCounterAmount

struct SignInConfigurationTests {
    @Test func `Pasted credential whitespace is removed`() {
        let configuration = SignInConfiguration(applicationID: " sq0idp-example\n", accessToken: " token\n", locationID: " location ")
        #expect(configuration.isValid)
        #expect(configuration.applicationID == "sq0idp-example")
        #expect(configuration.accessToken == "token")
        #expect(configuration.locationID == "location")
    }

    @Test(arguments: ["sq0idp-example", "sandbox-sq0idb-example"])
    func `Production and sandbox application IDs are accepted`(applicationID: String) {
        #expect(SignInConfiguration(applicationID: applicationID, accessToken: "token", locationID: "location").isValid)
    }

    @Test(arguments: ["", "sq0idp-", "sandbox-sq0idb-", "not-an-application-id"])
    func `Missing or malformed application IDs cannot initialize the SDK`(applicationID: String) {
        #expect(!SignInConfiguration(applicationID: applicationID, accessToken: "token", locationID: "location").isValid)
    }

    @Test func `Sign in needs both token and location`() {
        #expect(!SignInConfiguration(applicationID: "sq0idp-example", accessToken: " \n", locationID: "location").isValid)
        #expect(!SignInConfiguration(applicationID: "sq0idp-example", accessToken: "token", locationID: " ").isValid)
    }

    @Test func `Authorization diagnostics hide submitted credentials`() {
        let configuration = SignInConfiguration(applicationID: "sq0idp-example", accessToken: "sensitive-token", locationID: "private-location")
        let error = NSError(domain: "ExampleAuthorization", code: 9, userInfo: [
            "com.squareup.MobilePaymentsSDK.ErrorDebugMessage": "Rejected sensitive-token for sq0idp-example at private-location",
            "com.squareup.MobilePaymentsSDK.ErrorDebugCode": "invalidToken",
        ])
        let message = configuration.failureMessage(for: error)
        #expect(message.contains("invalidToken"))
        #expect(!message.contains(configuration.accessToken))
        #expect(!message.contains(configuration.applicationID))
        #expect(!message.contains(configuration.locationID))
    }
}
