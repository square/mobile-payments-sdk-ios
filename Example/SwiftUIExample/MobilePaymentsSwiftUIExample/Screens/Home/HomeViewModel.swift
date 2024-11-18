import SquareMobilePaymentsSDK

#if canImport(MockReaderUI)
import MockReaderUI
#endif

@Observable class HomeViewModel: PaymentManagerDelegate {
    
    enum PaymentStatus {
        case completed(Payment)
        case failure(Error)
        case canceled
    }

    var showPaymentStatusAlert: Bool = false
    var lastPaymentStatus: PaymentStatus? = nil
    var authorizationState: AuthorizationState

    let mobilePaymentsSDK: SDKManager
    let idempotencyKeyStorage: IdempotencyKeyStorage<String> = IdempotencyKeyStorage()
    
    #if canImport(MockReaderUI)
    var mockReader: MockReaderUI? = nil
    #endif

    init(mobilePaymentsSDK: SDKManager) {
        self.mobilePaymentsSDK = mobilePaymentsSDK
        self.authorizationState = mobilePaymentsSDK.authorizationManager.state
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
            print("Finished payment with ID: \(onlinePayment.id!) status: \(onlinePayment.status.description)")
        } else if let offlinePayment = payment as? OfflinePayment {
            print("Finished payment with ID: \(offlinePayment.localID) status: \(offlinePayment.status.description)")
        }

        // Upon completion of the order, generate a new custom ID (serving as your unique business-logic ID),
        // so that subsequent transactions are assigned a distinct idempotency key. The sale or order is considered
        // finalized at this stage.
        //
        // In a production application, this ID would usually be set when obtaining a unique identifier
        // for the transaction from your backend or generating it locally, prior to calling the
        // `startPayment` method.
        Config.localSalesID = String(UUID().uuidString.prefix(8))
        
        lastPaymentStatus = .completed(payment)
        showPaymentStatusAlert = true
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
            // These errors surface before the idempotency key is used, so there is no need to delete the key.
            print(error)
        case .idempotencyKeyReused:
            print("Developer error: Idempotency key reused. Check the most recent payments to see their status.")
            // The idempotency key has been utilized at this point, yet the transaction was unsuccessful.
            // It is essential to delete the idempotency key associated with this sale, allowing
            // a new key to be generated if the transaction is retried using the same sales ID.
            idempotencyKeyStorage.delete(id: Config.localSalesID)
        default:
            print(error)
            // Same as the case above, we need to ensure that this sale is no longer associated with this
            // idempotency key since it has been used, and a new key will be generated when the payment is restarted.
            idempotencyKeyStorage.delete(id: Config.localSalesID)
        }

        lastPaymentStatus = .failure(error)
        showPaymentStatusAlert = true
    }

    func paymentManager(
        _ paymentManager: PaymentManager,
        didCancel payment: Payment
    ) {
        print("\(#function)")
        
        // The idempotency key has presumably been utilized at this point, yet the transaction was cancelled.
        // It is essential to delete the idempotency key associated with this sale, allowing
        // a new key to be generated if the transaction is retried using the same custom ID.
        idempotencyKeyStorage.delete(id: Config.localSalesID)
        
        lastPaymentStatus = .canceled
        showPaymentStatusAlert = true
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
