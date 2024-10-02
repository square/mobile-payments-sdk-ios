import MockReaderUI
import SquareMobilePaymentsSDK
import SwiftUI

struct HomeView: View {

    @State private var isAuthorized: Bool = false
    @State private var isMockReaderPresented: Bool = false
    @State private var presentingPermissionsView: Bool = false
    private let viewHolder: MobilePaymentsSDKViewHolder = MobilePaymentsSDKViewHolder()
    private var mobilePaymentsSDK: SDKManager { viewModel.mobilePaymentsSDK }

    @ObservedObject var viewModel: HomeViewModel

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
                VStack {
                    Spacer()
                    itemView
                    Spacer()
                }
                footerView
            }
            .alert(isPresented: $viewModel.showPaymentStatusAlert) {
                return switch viewModel.lastPaymentStatus {
                case .completed(let payment):
                    Alert(
                        title: Text("Payment Completed!"),
                        message: Text("\(payment.paymentDescription?.debugDescription ?? "")")
                    )
                case .failure(let error):
                    Alert(
                        title: Text("Payment Failed!"),
                        message: Text("\(error.localizedDescription)")
                    )
                case .canceled, .none:
                    Alert(title: Text("Payment Canceled"))
                }
            }
        }
        .onAppear {
            self.isAuthorized = mobilePaymentsSDK.authorizationManager.state == .authorized
        }
        .padding()
        .background(Color.teal)
    }

    private var headerView: some View {
        HStack {
            settingsButton
            Spacer()
            authorizeButton
            permissionsButton
        }
    }

    private var itemView: some View {
        VStack {
            Image("iconCookie")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
            Text("Super Cookie")
                .font(.title)
                .padding(4)
            Text("Instantly gain special powers when ordering a super cookie")
                .font(.headline)
            buyButton
                .padding()
        }
        .foregroundStyle(.white)
        .fontWeight(.bold)
        .buttonStyle(AppButton())
    }

    private var footerView: some View {
        mockReaderButton
            .buttonStyle(AppButton())
    }

    // MARK: - Authorize Button

    private var authorizeButton: some View {
        Button(
            action: authorize,
            label: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 34)
            }
        )
        .buttonStyle(IconButton())
        .disabled(isAuthorized)
    }

    // MARK: - Permissions Button

    private var permissionsButton: some View {
        Button(
            action: { presentingPermissionsView = true },
            label: {
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 34)
            }
        )
        .sheet(
            isPresented: $presentingPermissionsView
        ) {
            // https://developer.squareup.com/docs/mobile-payments-sdk/ios#privacy-permissions
            PermissionsView(viewModel: PermissionsViewModel())
        }
        .buttonStyle(IconButton())
    }

    // MARK: - Settings Button

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
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 34)
            }
        )
        .buttonStyle(
            IconButton()
        )
    }

    // MARK: - Mock Reader Button

    @ViewBuilder
    private var mockReaderButton: some View {
        // MockReaderUI only works in the Sandbox environment
        if mobilePaymentsSDK.settingsManager.sdkSettings.environment == .sandbox {
            Button(
                action: {
                    defer {
                        self.isMockReaderPresented = viewModel.mockReader?.isPresented ?? false
                    }

                    if viewModel.mockReader == nil {
                        if mobilePaymentsSDK.settingsManager.sdkSettings.environment == .sandbox {
                            do {
                                self.viewModel.mockReader = try MockReaderUI(for: mobilePaymentsSDK)
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }

                    // If the reader is already presented, dismiss it otherwise present it
                    if let mockReader = viewModel.mockReader, mockReader.isPresented {
                        viewModel.mockReader?.dismiss()
                    } else {
                        do {
                            try viewModel.mockReader?.present()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                },
                label: { Text(isMockReaderPresented ? "Hide MockReaderUI" : "Show MockReaderUI") }
            )
        }
    }

    // MARK: - Buy Button

    private var buyButton: some View {
        Button(
            action: {
                // https://square.github.io/mobile-payments-sdk-ios/docs/documentation/mobilepaymentssdkapi/paymentparameters#instance-properties
                let paymentParameters = PaymentParameters(
                    idempotencyKey: UUID().uuidString,
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
            label: { Text("Buy for $1") }
        )
        .disabled(!isAuthorized)
    }
    
    // MARK: - Authorization
    
    private func authorize() {
        guard let accessToken = Config.accessToken,
              let locationID = Config.locationID else {
            fatalError("Replace the values in Config.swift with values from your Square account")
        }

        guard mobilePaymentsSDK.authorizationManager.state == .notAuthorized else {
            self.isAuthorized = true
            print("Already authorized")
            return
        }
        // https://developer.squareup.com/docs/mobile-payments-sdk/ios/configure-authorize
        mobilePaymentsSDK.authorizationManager.authorize(
            withAccessToken: accessToken,
            locationID: locationID
        ) { error in
            self.isAuthorized = error == nil
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(mobilePaymentsSDK: MockMobilePaymentsSDK()))
}
