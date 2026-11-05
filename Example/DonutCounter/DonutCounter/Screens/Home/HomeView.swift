import SquareMobilePaymentsSDK
import SwiftUI

#if canImport(MockReaderUI)
import MockReaderUI
#endif

struct HomeView: View {
    
    private enum Constants {
        static let headerViewBottomPadding: CGFloat = 12
        static let appNameTextBottomPadding: CGFloat = 16
        static let authorizationStatusTextTopPadding: CGFloat = 10
        static let iPadPadding: CGFloat = 50
    }
    
    @SwiftUI.Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var presentingAccountView: Bool = false
    @State private var isMockReaderPresented: Bool = false
    @State private var viewModel: HomeViewModel
    @Bindable private var session: AppSession
    @State private var enteredAmount: MoneyAmountEntry
    @State private var selectedProcessingMode = LabProcessingMode.automatic
    @SwiftUI.Environment(\.scenePhase) private var scenePhase
    
    private var mobilePaymentsSDK: SDKManager { viewModel.mobilePaymentsSDK }
    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    private var isMockReaderAvailable: Bool {
        #if canImport(MockReaderUI)
        return viewModel.authorizationState == .authorized && mobilePaymentsSDK.settingsManager.sdkSettings.environment == .sandbox
        #else
        return false
        #endif
    }
    
    private let viewHolder: MobilePaymentsSDKViewHolder = MobilePaymentsSDKViewHolder()

    init(viewModel: HomeViewModel, session: AppSession) {
        self.viewModel = viewModel
        self.session = session
        _enteredAmount = State(initialValue: MoneyAmountEntry(currencyCode: session.currency.rawValue, locale: .current))
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
        .onAppear { viewModel.refreshOfflineQueue() }
        .onChange(of: session.currency) { _, currency in
            enteredAmount = MoneyAmountEntry(currencyCode: currency.rawValue, locale: .current)
            viewModel.lastPaymentResult = nil
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { viewModel.refreshOfflineQueue() }
        }
        .onChange(of: viewModel.authorizationState) { oldValue, newValue in
            if newValue == .notAuthorized {
                // Mock reader is required to be in an authorized sandbox environment
                dismissMockReader()
            }
            viewModel.refreshOfflineQueue()
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            settingsButton
            Spacer()
            accountButton
        }
        .padding(.bottom, Constants.headerViewBottomPadding)
    }

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("DonutCounter")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.bottom], Constants.appNameTextBottomPadding)
                Picker(NSLocalizedString("Currency", comment: "Payment currency selector"), selection: $session.currency) {
                    ForEach(TestCurrency.allCases) { currency in
                        Text(currency.title).tag(currency)
                    }
                }
                .accessibilityIdentifier("paymentCurrency")
                MoneyKeypadView(amount: $enteredAmount)
                if !session.currencyMatchesLocation {
                    Text(String(format: NSLocalizedString("This location accepts %@. Select that currency to take a payment.", comment: "Prevent charging a currency incompatible with the authorized location"), session.locationCurrency?.rawValue ?? NSLocalizedString("an unsupported currency", comment: "Unknown location currency")))
                        .foregroundStyle(Color.Text.warning)
                        .accessibilityIdentifier("currencyMismatch")
                }
                Picker(NSLocalizedString("Payment processing", comment: "Label for selecting automatic, online-only or offline-only payments"), selection: $selectedProcessingMode) {
                    ForEach(LabProcessingMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
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
                if let result = viewModel.lastPaymentResult {
                    Text(result)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("paymentResult")
                }
                if viewModel.authorizationState == .authorized {
                    Text(viewModel.offlineQueueSummary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("offlineQueueSummary")
                    Button(NSLocalizedString("Refresh offline payments", comment: "Refresh the stored offline payment records and their current upload status")) { viewModel.refreshOfflineQueue() }
                }
            }
        }
    }

    // MARK: - Buttons

    private var accountButton: some View {
        Button(
            action: { presentingAccountView = true },
            label: {
                Text(NSLocalizedString("Account", comment: "Open credentials, currency, and permissions settings"))
            }
        )
        .fullScreenCover(isPresented: $presentingAccountView, content: {
            AccountView(session: session, canDismiss: true)
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
                guard session.currencyMatchesLocation, let amount = enteredAmount.payableAmount else { return }
                viewModel.lastPaymentResult = nil
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
                        amount: amount,
                        currency: session.currency.sdkCurrency
                    ),
                    processingMode: processingMode()
                )

                // https://square.github.io/mobile-payments-sdk-ios/docs/documentation/mobilepaymentssdkapi/promptparameters#instance-properties
                let promptParameters = PromptParameters(
                    mode: .default,
                    additionalMethods: selectedProcessingMode == .offline ? AdditionalPaymentMethods([]) : .keyed
                )

                // https://developer.squareup.com/docs/mobile-payments-sdk/ios/take-payments
                mobilePaymentsSDK.paymentManager.startPayment(
                    paymentParameters,
                    promptParameters: promptParameters,
                    from: viewHolder.controller,
                    delegate: viewModel
                )
            },
            label: {
                Text(enteredAmount.payableAmount == nil
                    ? NSLocalizedString("Enter an amount", comment: "Payment button when no amount has been entered")
                    : String(format: NSLocalizedString("Charge %@", comment: "Payment button with formatted money"), enteredAmount.formattedAmount))
            }
        )
        .disabled(viewModel.authorizationState != .authorized || enteredAmount.payableAmount == nil || !session.currencyMatchesLocation)
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
        return selectedProcessingMode.sdkMode
    }
}

private enum LabProcessingMode: String, CaseIterable, Identifiable {
    case automatic, online, offline

    var id: Self { self }

    var title: String {
        switch self {
        case .automatic: NSLocalizedString("Automatic", comment: "Automatically select online or offline processing")
        case .online: NSLocalizedString("Online", comment: "Online-only payment processing")
        case .offline: NSLocalizedString("Offline", comment: "Offline-only payment processing")
        }
    }

    var sdkMode: ProcessingMode {
        switch self {
        case .automatic: .autoDetect
        case .online: .onlineOnly
        case .offline: .offlineOnly
        }
    }
}
