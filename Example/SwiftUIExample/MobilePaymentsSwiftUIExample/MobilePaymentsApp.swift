import SwiftUI
import SquareMobilePaymentsSDK

class AppDelegate: NSObject, UIApplicationDelegate {

    var mobilePaymentSDK: SDKManager!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        MobilePaymentsSDK.initialize(squareApplicationID: Config.squareApplicationID)
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
