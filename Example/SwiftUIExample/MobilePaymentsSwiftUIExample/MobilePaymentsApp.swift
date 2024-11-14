import SwiftUI
import SquareMobilePaymentsSDK

class AppDelegate: NSObject, UIApplicationDelegate {

    private(set) var mobilePaymentSDK: SDKManager!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        guard let applicationId = Config.squareApplicationID else {
            fatalError("Replace the values in Config.swift with values from your Square account")
        }
        MobilePaymentsSDK.initialize(squareApplicationID: applicationId)
        self.mobilePaymentSDK = MobilePaymentsSDK.shared
        return true
    }
}

@main
struct MobilePaymentsExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(mobilePaymentsSDK: appDelegate.mobilePaymentSDK))
        }
    }
}
