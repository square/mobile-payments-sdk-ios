import SquareMobilePaymentsSDK
import SwiftUI

#if canImport(MockReaderUI)
import MockReaderUI
#endif

struct HomeView: View {
    
    private enum Constants {
        static let headerViewBottomPadding: CGFloat = 50
        static let donutImageWidth: CGFloat = 248
        static let donutImageBottomPadding: CGFloat = 50
        static let appNameTextBottomPadding: CGFloat = 32
        static let authorizationStatusTextTopPadding: CGFloat = 10
        static let iPadPadding: CGFloat = 50
    }
    
    @SwiftUI.Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var presentingPermissionsView: Bool = false
    @State private var isMockReaderPresented: Bool = false
    @State private var viewModel: HomeViewModel
    
    private var mobilePaymentsSDK: SDKManager { viewModel.mobilePaymentsSDK }
    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    private var isMockReaderAvailable: Bool {
        viewModel.authorizationState == .authorized && mobilePaymentsSDK.settingsManager.sdkSettings.environment == .sandbox
    }
    
    private let viewHolder: MobilePaymentsSDKViewHolder = MobilePaymentsSDKViewHolder()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        // Some APIs of SquareMobilePaymentsSDK require a UIViewController,
        // you can use a UIViewControllerRepresentable with an empty UIViewController
        // and put it on the bottom of a ZStack
        ZStack {
            viewHolder
            VStack {
                headerView
                contentView
                Spacer()
                if isMockReaderAvailable {
                    mockReaderButton
                }
            }
        }
        .padding([.leading, .trailing], isIPad ? Constants.iPadPadding : nil)
        .padding([.top, .bottom])
        .background(Color.white)
        .onChange(of: viewModel.authorizationState) { oldValue, newValue in
            if newValue == .notAuthorized {
                // Mock reader is required to be in an authorized sandbox environment
                dismissMockReader()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            settingsButton
            Spacer()
            permissionsButton
        }
        .padding(.bottom, Constants.headerViewBottomPadding)
    }

    private var contentView: some View {
        VStack {
            Image("donut")
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: Constants.donutImageWidth)
                .padding(.bottom, Constants.donutImageBottomPadding)
            Text(String.Home.appTitle)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding([.bottom], Constants.appNameTextBottomPadding)
            buyDonutButton
                .buttonStyle(BuyButtonStyle())
                .font(.body)
                .fontWeight(.semibold)
            if viewModel.authorizationState != .authorized {
                Text(String.Home.notAuthorized)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    .foregroundStyle(Color.Text.warning)
                    .padding(.top, Constants.authorizationStatusTextTopPadding)
            }
        }
    }

    // MARK: - Buttons

    private var permissionsButton: some View {
        Button(
            action: { presentingPermissionsView = true },
            label: {
                Text(String.Home.permissionsButtonTitle)
            }
        )
        .fullScreenCover(isPresented: $presentingPermissionsView, content: {
            // https://developer.squareup.com/docs/mobile-payments-sdk/ios#privacy-permissions
            PermissionsView(
                viewModel: PermissionsViewModel(
                    mobilePaymentsSDK: mobilePaymentsSDK
                ),
                presentingPermissionsView: $presentingPermissionsView
            )
        })
        .buttonStyle(HeaderButtonStyle())
    }

    private var settingsButton: some View {
        Button(
            action: {
                // https://developer.squareup.com/docs/mobile-payments-sdk/ios/pair-manage-readers
                mobilePaymentsSDK.settingsManager.presentSettings(
                    with: viewHolder.controller
                ) { error in
                    if let error {
                        print(
                            error.localizedDescription
                        )
                    }
                }
            },
            label: {
                Text(String.Home.settingsButtonTitle)
            }
        )
        .buttonStyle(
            HeaderButtonStyle()
        )
    }
    
    private var buyDonutButton: some View {
        Button(
            action: {
                // Generate a paymentAttemptID to be used for this payment.
                // Your actual implementation should not be as simple as generating a UUID before
                // starting the payment. The ID should be generated based on some type of order/sales ID
                // in order to prevent duplicate payments.
                // See our documentation for tips and best practices: https://developer.squareup.com/docs/mobile-payments-sdk/ios#7-set-up-a-payment
                let paymentAttemptID = UUID().uuidString

                // https://square.github.io/mobile-payments-sdk-ios/docs/documentation/mobilepaymentssdkapi/paymentparameters#instance-properties
                let paymentParameters = PaymentParameters(
                    paymentAttemptID: paymentAttemptID,
                    amountMoney: Money(
                        amount: 100,
                        currency: .USD
                    ),
                    processingMode: processingMode()
                )

                // https://square.github.io/mobile-payments-sdk-ios/docs/documentation/mobilepaymentssdkapi/promptparameters#instance-properties
                let promptParameters = PromptParameters(
                    mode: .default,
                    additionalMethods: .all
                )

                // https://developer.squareup.com/docs/mobile-payments-sdk/ios/take-payments
                mobilePaymentsSDK.paymentManager.startPayment(
                    paymentParameters,
                    promptParameters: promptParameters,
                    from: viewHolder.controller,
                    delegate: viewModel
                )
            },
            label: { Text(String.Home.buyDonutButtonTitle) }
        )
        .disabled(viewModel.authorizationState != .authorized)
    }
    
    private var mockReaderButton: some View {
        Button {
            if isMockReaderPresented {
                dismissMockReader()
            } else {
                presentMockReader()
            }
            
        } label: {
            if isMockReaderPresented {
                Text(String.Home.MockReaderButton.hideMockReaderTitle)
            } else {
                Text(String.Home.MockReaderButton.showMockReaderTitle)
            }
        }
        .font(.body)
        .fontWeight(.semibold)
    }
    
    // MARK: - Mock Reader UI
    
    private func presentMockReader() {
        #if canImport(MockReaderUI)
        guard isMockReaderAvailable else { return }
        
        // Present mock reader
        do {
            if viewModel.mockReader == nil {
                self.viewModel.mockReader = try MockReaderUI(for: mobilePaymentsSDK)
            }
            
            if let mockReader = viewModel.mockReader, !isMockReaderPresented {
                try mockReader.present()
                isMockReaderPresented = true
            }
        } catch (let error) {
            print("Mock Reader Error: \(error.localizedDescription)")
        }
        #endif
    }
    
    private func dismissMockReader() {
        #if canImport(MockReaderUI)
        guard let mockReader = viewModel.mockReader, isMockReaderPresented else { return }
        mockReader.dismiss()
        isMockReaderPresented = false
        #endif
    }

    private func processingMode() -> ProcessingMode {
        // Sandbox mode currently only supports onlineOnly payments.
        if viewModel.settingsManager.sdkSettings.environment == .sandbox {
            return .onlineOnly
        }
        return .autoDetect
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(mobilePaymentsSDK: MockMobilePaymentsSDK()))
}
