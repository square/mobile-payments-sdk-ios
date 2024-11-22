//
//  Payment+Extensions.swift
//  MobilePaymentsSwiftUIExample
//
//  Created by Tamer Bader on 11/12/24.
//  Copyright © 2024 Square, Inc. All rights reserved.
//

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
