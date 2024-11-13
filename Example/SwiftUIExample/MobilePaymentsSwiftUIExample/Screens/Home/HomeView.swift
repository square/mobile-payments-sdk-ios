import SquareMobilePaymentsSDK
import SwiftUI

#if canImport(MockReaderUI)
import MockReaderUI
#endif

struct HomeView: View {

    @State private var presentingPermissionsView: Bool = false
    @ObservedObject var viewModel: HomeViewModel
    
    private let viewHolder: MobilePaymentsSDKViewHolder = MobilePaymentsSDKViewHolder()
    private var mobilePaymentsSDK: SDKManager { viewModel.mobilePaymentsSDK }
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

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
            }
            .alert(isPresented: $viewModel.showPaymentStatusAlert) {
                paymentStatusAlert
            }
        }
        .padding([.leading, .trailing], isIPad ? 50 : nil)
        .padding([.top, .bottom])
        .background(Color.white)
        .onAppear (perform: setupMockReader)
        .onChange(of: viewModel.authorizationState, perform: { _ in
            setupMockReader()
        })
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            settingsButton
            Spacer()
            permissionsButton
        }
        .padding(.bottom, 50)
    }

    private var contentView: some View {
        VStack {
            Image("donut")
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: 248)
                .padding(.bottom, 54)
            Text(String.Home.appTitle)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding([.bottom], 32)
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
                    .padding(.top, 10)
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
                    mobilePaymentsSDK: mobilePaymentsSDK,
                    authorizationState: $viewModel.authorizationState
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
                // https://developer.squareup.com/docs/mobile-payments-sdk/ios/take-payments#idempotency-keys
                // Retrieves an idempotency key associated with the current sales ID from storage. If no existing key is found,
                // a new UUID is generated and stored as the idempotency key for that sales ID. The retrieved or newly generated
                // idempotency key is then assigned to the payment parameters, ensuring that the transaction maintains its uniqueness,
                // even if it needs to be retried.
                let idempotencyKey = viewModel.idempotencyKeyStorage.get(id: Config.localSalesID) ?? {
                    let newKey = UUID().uuidString
                    viewModel.idempotencyKeyStorage.store(id: Config.localSalesID, idempotencyKey: newKey)
                    return newKey
                }()
                
                // https://square.github.io/mobile-payments-sdk-ios/docs/documentation/mobilepaymentssdkapi/paymentparameters#instance-properties
                let paymentParameters = PaymentParameters(
                    idempotencyKey: idempotencyKey,
                    amountMoney: Money(
                        amount: 100,
                        currency: .USD
                    )
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
    
    // MARK: - Alerts
    
    private var paymentStatusAlert: Alert {
        switch viewModel.lastPaymentStatus {
        case .completed(let payment):
            Alert(
                title: Text(String.Home.PaymentStatusAlert.paymentCompletedTitle),
                message: Text("\(payment.paymentDescription?.debugDescription ?? "")")
            )
        case .failure(let error):
            Alert(
                title: Text(String.Home.PaymentStatusAlert.paymentFailedTitle),
                message: Text("\(error.localizedDescription)")
            )
        case .canceled, .none:
            Alert(title: Text(String.Home.PaymentStatusAlert.paymentCanceledTitle))
        }
    }
    
    // MARK: - Private Methods
    private func setupMockReader() {
        #if canImport(MockReaderUI)
        // Mock reader is only available in an authorized sandbox environment.
        guard mobilePaymentsSDK.authorizationManager.state == .authorized,
              mobilePaymentsSDK.settingsManager.sdkSettings.environment == .sandbox 
        else {
            viewModel.mockReader?.dismiss()
            viewModel.mockReader = nil
            return
        }
        
        // Present mock reader
        do {
            if viewModel.mockReader == nil {
                self.viewModel.mockReader = try MockReaderUI(for: mobilePaymentsSDK)
            }
            
            if let mockReader = viewModel.mockReader {
                try mockReader.present()
            }
        } catch (let error) {
            print("Mock Reader Error: \(error.localizedDescription)")
        }
        #endif
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(mobilePaymentsSDK: MockMobilePaymentsSDK()))
}
