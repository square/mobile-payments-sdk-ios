//
//  String+Extensions.swift
//  MobilePaymentsSwiftUIExample
//
//  Created by Tamer Bader on 11/12/24.
//  Copyright © 2024 Square, Inc. All rights reserved.
//

import Foundation

extension String {
    
    enum Home {
        static var appTitle: String = "Donut Counter"
        static var notAuthorized: String = "Device not authorized. Open permissions to authorize."
        static var permissionsButtonTitle: String = "Permissions"
        static var settingsButtonTitle: String = "Settings"
        static var buyDonutButtonTitle: String = "Buy for $1"
        
        enum PaymentStatusAlert {
            static var paymentCompletedTitle: String = "Payment Completed!"
            static var paymentFailedTitle: String = "Payment Failed!"
            static var paymentCanceledTitle: String = "Payment Canceled"
        }
    }
    
    enum Permissions {
        static var headerTitle: String = "Permissions"
        
        enum Bluetooth {
            static var bluetoothPermissionTitle: String = "Bluetooth"
            static var bluetoothPermissionDescription: String = "Square uses Bluetooth to connect and communicate with Square devices. \nYou should ask for this permission if you are using readers that connect via Bluetooth."
        }
        
        enum Location {
            static var locationPermissionTitle: String = "Location"
            static var locationPermissionDescription: String = "Square used location to know where transactions take place. This reduces risk and minimizes payment disputes."
        }
        
        enum Microphone {
            static var microphonePermissionTitle: String = "Microphone"
            static var microphonePermissionDescription: String = "Square’s R4 reader uses the microphone jack to communicate payment card data to your device. You should ask for this permission if you are using an R4 reader."
        }
        
        enum AuthorizationButton {
            static var authorizeTitle: String = "Sign In"
            static var deauthorizeTitle: String = "Sign out"
        }
    }
}
