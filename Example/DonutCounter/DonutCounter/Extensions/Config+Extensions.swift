//
//  Config+Extensions.swift
//  MobilePaymentsSwiftUIExample
//
//  Created by Tamer Bader on 11/13/24.
//  Copyright © 2024 Square, Inc. All rights reserved.
//

import Foundation

extension Config {
    /// In this sample app, `localSalesID` serves as a unique, hypothetical identifier for a transaction within the business logic of your application.
    /// It's utilized here to demonstrate how one might manage idempotency. In your actual application, the structure and logic for your business logic ID may vary.
    /// The use of an idempotency key, alongside a custom ID like this, ensures that even if a transaction is retried, it will not be duplicated.
    /// If a transaction fails and needs to be retried with the same ID, a new idempotency key is generated, thereby maintaining the integrity of the transaction and preventing inadvertent duplication.
    static var localSalesID: String = String(UUID().uuidString.prefix(8))
}
