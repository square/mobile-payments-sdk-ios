import Foundation
import Observation
import SquareMobilePaymentsSDK

#if canImport(MockReaderUI)
import MockReaderUI
#endif

@Observable class HomeViewModel: PaymentManagerDelegate {

    var authorizationState: AuthorizationState

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
            print("Finished online payment with ID: \(onlinePayment.id!) status: \(onlinePayment.status.description)")
        } else if let offlinePayment = payment as? OfflinePayment {
            print("Finished offline payment with ID: \(offlinePayment.localID) status: \(offlinePayment.status.description)")
        }
    }

    func paymentManager(
        _ paymentManager: PaymentManager,
        didFail payment: Payment,
        withError error: Error
    ) {
        // https://developer.squareup.com/docs/mobile-payments-sdk/ios/handling-errors#payment-errors
        let paymentError = PaymentError(rawValue: (error as NSError).code)
        switch paymentError {
        case .paymentAlreadyInProgress,
                .notAuthorized,
                .timedOut:
            print(error)
        case .paymentAttemptIdReused:
            print("Developer error: Payment attempt ID reused. Check the most recent payments to see their status.")
        default:
            print(error)
        }
    }

    func paymentManager(
        _ paymentManager: PaymentManager,
        didCancel payment: Payment
    ) {
        print("\(#function)")
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
