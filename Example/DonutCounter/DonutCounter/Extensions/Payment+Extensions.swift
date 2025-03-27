import Foundation
import SquareMobilePaymentsSDK

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
