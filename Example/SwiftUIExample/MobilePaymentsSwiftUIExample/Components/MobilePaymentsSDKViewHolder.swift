import SwiftUI

/// UIViewControllerRepresentable for usage of a UIViewController in the SquareMobilePaymentsSDK APIs that need a UIViewController
struct MobilePaymentsSDKViewHolder: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    let controller = UIViewController()

    func makeUIViewController(context: Context) -> UIViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
