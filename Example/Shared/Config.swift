public enum Config {
    static let squareApplicationID: String? = nil // Replace with your squareApplicationID

    // In a production application you should use your server to obtain an access token and locationID.
    // For this sample app, we can just authorize Square Mobile Payments SDK using hardcoded values.
    static let accessToken: String? = nil // Replace with your accessToken
    static let locationID: String? = nil // Replace with your locationID
}
