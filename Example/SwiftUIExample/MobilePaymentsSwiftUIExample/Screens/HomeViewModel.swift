//
//  HomeViewModel.swift
//  MobilePaymentsExample
//
//  Created by Brandon Jenniges on 6/12/24.
//

import MockReaderUI
import SquareMobilePaymentsSDK

enum PaymentStatus {
    case completed(Payment)
    case failure(Error)
    case canceled
}

class HomeViewModel: ObservableObject, PaymentManagerDelegate {

    @Published var showPaymentStatusAlert: Bool = false
    @Published var lastPaymentStatus: PaymentStatus? = nil

    let mobilePaymentsSDK: SDKManager
    var mockReader: MockReaderUI?

    init(mobilePaymentsSDK: SDKManager) {
        self.mobilePaymentsSDK = mobilePaymentsSDK
    }

    // MARK: - Payment Manager Delegate

    func paymentManager(
        _ paymentManager: PaymentManager,
        didFinish payment: Payment
    ) {
        // https://developer.squareup.com/docs/mobile-payments-sdk/ios/take-payments#overview
        print("\(#function) - \(String(describing: payment.paymentDescription))")
        lastPaymentStatus = .completed(payment)
        showPaymentStatusAlert = true
    }

    func paymentManager(
        _ paymentManager: PaymentManager,
        didFail payment: Payment,
        withError error: Error
    ) {
        // https://developer.squareup.com/docs/mobile-payments-sdk/ios/handling-errors#payment-errors
        print("\(#function) - \(error.localizedDescription)")
        lastPaymentStatus = .failure(error)
        showPaymentStatusAlert = true
    }

    func paymentManager(
        _ paymentManager: PaymentManager,
        didCancel payment: Payment
    ) {
        print("\(#function)")
        lastPaymentStatus = .canceled
        showPaymentStatusAlert = true
    }
}

extension Payment {
    // Helper function to get dictionaryRepresentation of the Payment
    var paymentDescription: [String: Any]? {
        if let onlinePayment = self as? OnlinePayment {
            return onlinePayment.dictionaryRepresentation
        } else if let offlinePayment = self as? OfflinePayment {
            return offlinePayment.dictionaryRepresentation
        }
        return nil
    }
}
