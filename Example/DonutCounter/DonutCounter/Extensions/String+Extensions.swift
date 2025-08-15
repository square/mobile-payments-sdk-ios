import Foundation

extension String {
    
    enum Home {
        static var appTitle: String = NSLocalizedString("Donut Counter", comment: "Main app title")
        static var notAuthorized: String = NSLocalizedString("Device not authorized. Open permissions to authorize.", comment: "Message shown when device is not authorized")
        static var permissionsButtonTitle: String = NSLocalizedString("Permissions", comment: "Title for permissions button")
        static var settingsButtonTitle: String = NSLocalizedString("Settings", comment: "Title for settings button")
        static var buyDonutButtonTitle: String = NSLocalizedString("Buy for $1", comment: "Title for buy donut button")
        
        enum PaymentStatusAlert {
            static var paymentCompletedTitle: String = NSLocalizedString("Payment Completed!", comment: "Title for payment completed alert")
            static var paymentFailedTitle: String = NSLocalizedString("Payment Failed!", comment: "Title for payment failed alert")
            static var paymentCanceledTitle: String = NSLocalizedString("Payment Canceled", comment: "Title for payment canceled alert")
        }
        
        enum MockReaderButton {
            static var showMockReaderTitle: String = NSLocalizedString("Show Mock Reader", comment: "Title for show mock reader button")
            static var hideMockReaderTitle: String = NSLocalizedString("Hide Mock Reader", comment: "Title for hide mock reader button")
        }
    }
    
    enum Permissions {
        static var headerTitle: String = NSLocalizedString("Permissions", comment: "Permissions screen header title")
        
        enum Bluetooth {
            static var bluetoothPermissionTitle: String = NSLocalizedString("Bluetooth", comment: "Bluetooth permission title")
            static var bluetoothPermissionDescription: String = NSLocalizedString("Square uses Bluetooth to connect and communicate with Square devices. \nYou should ask for this permission if you are using readers that connect via Bluetooth.", comment: "Bluetooth permission description")
        }
        
        enum Location {
            static var locationPermissionTitle: String = NSLocalizedString("Location", comment: "Location permission title")
            static var locationPermissionDescription: String = NSLocalizedString("Square uses location to know where transactions take place. This reduces risk and minimizes payment disputes.", comment: "Location permission description")
        }
        
        enum Microphone {
            static var microphonePermissionTitle: String = NSLocalizedString("Microphone", comment: "Microphone permission title")
            static var microphonePermissionDescription: String = NSLocalizedString("Square Reader for magstripe uses the microphone to communicate payment card data to your device. You should ask for this permission if you are using a magstripe reader.", comment: "Microphone permission description")
        }
        
        enum AuthorizationButton {
            static var authorizeTitle: String = NSLocalizedString("Sign In", comment: "Authorization button title")
            static var deauthorizeTitle: String = NSLocalizedString("Sign out", comment: "Deauthorization button title")
        }
    }
}
