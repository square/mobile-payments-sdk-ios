import SwiftUI
import SquareMobilePaymentsSDK

@MainActor class AppDelegate: NSObject, UIApplicationDelegate {
    let session = AppSession()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        session.initializeSavedApplication()
        return true
    }
}

@main
struct DonutCounterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if let sdk = appDelegate.session.sdk,
               appDelegate.session.authorizationState == .authorized,
               !appDelegate.session.isBusy,
               !appDelegate.session.requiresRestart {
                HomeView(viewModel: HomeViewModel(mobilePaymentsSDK: sdk), session: appDelegate.session)
            } else {
                AccountView(session: appDelegate.session)
            }
        }
    }
}
