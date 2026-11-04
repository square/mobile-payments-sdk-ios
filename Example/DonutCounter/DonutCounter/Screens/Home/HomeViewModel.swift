import Foundation
import Observation
import SquareMobilePaymentsSDK

#if canImport(MockReaderUI)
import MockReaderUI
#endif

@Observable class HomeViewModel: PaymentManagerDelegate {

    var authorizationState: AuthorizationState
    var lastPaymentResult: String?
    var offlineQueueSummary = ""

    let mobilePaymentsSDK: SDKManager
    let settingsManager: SettingsManager

    #if canImport(MockReaderUI)
    var mockReader: MockReaderUI? = nil
    #endif

    init(mobilePaymentsSDK: SDKManager) {
        self.mobilePaymentsSDK = mobilePaymentsSDK
        self.authorizationState = mobilePaymentsSDK.authorizationManager.state
        self.settingsManager = mobilePaymentsSDK.settingsManager
        self.mobilePaymentsSDK.authorizationManager.add(self)
        refreshAuthorizationState()
    }

    // MARK: - Payment Manager Delegate

    func paymentManager(
        _ paymentManager: PaymentManager,
        didFinish payment: Payment
    ) {
        // https://developer.squareup.com/docs/mobile-payments-sdk/ios/take-payments#overview
        if let onlinePayment = payment as? OnlinePayment {
            lastPaymentResult = String(format: NSLocalizedString("Online payment: %@", comment: "Online payment result"), onlinePayment.status.description)
        } else if let offlinePayment = payment as? OfflinePayment {
            lastPaymentResult = String(format: NSLocalizedString("Offline payment: %@\nLocal ID: %@", comment: "Stored offline payment result"), offlinePayment.status.description, offlinePayment.localID)
        }
        refreshOfflineQueue()
    }

    func paymentManager(
        _ paymentManager: PaymentManager,
        didFail payment: Payment,
        withError error: Error
    ) {
        // https://developer.squareup.com/docs/mobile-payments-sdk/ios/handling-errors#payment-errors
        lastPaymentResult = String(format: NSLocalizedString("Payment failed: %@", comment: "Payment error"), error.localizedDescription)
        refreshOfflineQueue()
    }

    func paymentManager(
        _ paymentManager: PaymentManager,
        didCancel payment: Payment
    ) {
        lastPaymentResult = NSLocalizedString("Payment canceled", comment: "Canceled payment result")
        refreshOfflineQueue()
    }

    func refreshOfflineQueue() {
        guard authorizationState == .authorized else {
            offlineQueueSummary = ""
            return
        }
        let allowance = settingsManager.paymentSettings.isOfflineProcessingAllowed
            ? NSLocalizedString("Offline payments enabled", comment: "Offline eligibility")
            : NSLocalizedString("Offline payments not enabled", comment: "Offline eligibility")
        mobilePaymentsSDK.paymentManager.offlinePaymentQueue.getPayments { [weak self] payments, error in
            Task { @MainActor [weak self] in
                guard let self, self.authorizationState == .authorized else { return }
                if let error {
                    self.offlineQueueSummary = allowance + "\n" + error.localizedDescription
                } else {
                    let rows = payments.map { "\($0.localID): \($0.status.description)" }
                    self.offlineQueueSummary = ([allowance, String(format: NSLocalizedString("Offline queue records: %ld", comment: "Number of stored offline payment records"), payments.count)] + rows).joined(separator: "\n")
                }
            }
        }
    }
    
    private func refreshAuthorizationState() {
        authorizationState = mobilePaymentsSDK.authorizationManager.state
    }
    
    deinit {
        mobilePaymentsSDK.authorizationManager.remove(self)
    }
}

// MARK: - AuthorizationStateObserver

extension HomeViewModel: AuthorizationStateObserver {
    func authorizationStateDidChange(_ authorizationState: AuthorizationState) {
        refreshAuthorizationState()
    }
}
