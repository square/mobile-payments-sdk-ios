import SwiftUI
import SquareMobilePaymentsSDK //add

struct PermissionsView: View {
    
    @ObservedObject var viewModel: PermissionsViewModel
    @Binding var presentingPermissionsView: Bool
    
    private var mobilePaymentsSDK: SDKManager { viewModel.mobilePaymentsSDK }
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    private var isAuthorized: Bool {
        viewModel.authorizationState == .authorized
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                headerView
                ScrollView {
                    permissionsView
                        .padding(.bottom, 16)
                    authorizationButton
                    authorizationStatus
                    Spacer()
                }
                .onAppear {
                    UIScrollView.appearance().bounces = false
                }
                .onDisappear {
                    UIScrollView.appearance().bounces = true
                }
            }
            .padding([.leading, .trailing], isIPad ? 50 : nil)
            .padding([.top, .bottom])
        }
        .background(.white)
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Button {
                presentingPermissionsView = false
            } label: {
                Image(systemName: "xmark")
                    .font(.body)
                    .fontWeight(.medium)
            }
            .buttonStyle(DismissButton())
            Spacer()
            Text(String.Permissions.headerTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .padding(.trailing, 45)
            
            Spacer()
        }
    }
    
    private var permissionsView: some View {
        VStack {
            // Bluetooth
            PermissionsRow(title: String.Permissions.Bluetooth.bluetoothPermissionTitle,
                           description: String.Permissions.Bluetooth.bluetoothPermissionDescription,
                           isPermissionGranted: viewModel.isBluetoothPermissionGranted
            ) {
                viewModel.requestBluetooth()
            }
            
            Divider()
            
            // Location
            PermissionsRow(title: String.Permissions.Location.locationPermissionTitle,
                           description: String.Permissions.Location.locationPermissionDescription,
                           isPermissionGranted: viewModel.isLocationPermissionGranted
            ) {
                viewModel.requestLocation()
            }
            
            Divider()
            
            // Mirophone
            PermissionsRow(title: String.Permissions.Microphone.microphonePermissionTitle,
                           description: String.Permissions.Microphone.microphonePermissionDescription,
                           isPermissionGranted: viewModel.isMicrophonePermissionGranted
            ) {
                viewModel.requestMicrophone()
            }
        }
    }
    
    private var authorizationButton: some View {
        return Button(
            action: {
                if viewModel.authorizationState == .notAuthorized {
                    authorize()
                } else if viewModel.authorizationState == .authorized {
                    deauthorize()
                }
            },
            label: {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.black)
                } else {
                    Text(isAuthorized ?  String.Permissions.AuthorizationButton.deauthorizeTitle: String.Permissions.AuthorizationButton.authorizeTitle )
                }
            }
        )
        .frame(height: 48)
        .buttonStyle(AuthorizationButtonStyle(isAuthorized: isAuthorized))
        .font(.headline)
        .disabled(viewModel.isLoading)
    }
    
    private var authorizationStatus: some View {
        
        Text(authorizationStatusText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .font(.subheadline)
            .foregroundStyle(authorizationStatusForegroundColor)
            .padding(.top, 10)
    }
    
    // MARK: - Private Properties
    
    var authorizationStateLabel: AuthorizationStateLabel {
        if (viewModel.authorizationFailed) {
            return .error("Authorization Failed")
        }
        switch (viewModel.authorizationState, viewModel.isLoading) {
        case (.authorized, false):
            return .success("This device is authorized.")
        case (.authorized, true):
            return .loading("Deauthorizing...")
        case (.notAuthorized, false):
            return .warning("Device not authorized.")
        case (.notAuthorized, true):
            return .loading("Authorizing...")
        default:
            fatalError("Invalid authorization state")
        }
    }
    
    private var authorizationStatusText: String {
        switch authorizationStateLabel {
        case .warning(let string),
                .error(let string),
                .success(let string),
                .loading(let string):
            return string
        }
    }
    
    private var authorizationStatusForegroundColor: Color {
        switch authorizationStateLabel {
        case .warning(_):
            Color.Text.warning
        case .error(_):
            Color.Text.error
        case .success(_):
            Color.Text.success
        case .loading(_):
            Color.Text.normal
        }
    }
    
    // MARK: - Private Methods
    
    private func authorize() {
        viewModel.isLoading = true
        viewModel.authorizationFailed = false
        
        // https://developer.squareup.com/docs/mobile-payments-sdk/ios#4-authorize-the-mobile-payments-sdk
        mobilePaymentsSDK.authorizationManager.authorize(
            withAccessToken: Config.accessToken,
            locationID: Config.locationID
        ) { error in
            viewModel.isLoading = false
            if let error {
                viewModel.authorizationFailed = true
                print("Failed to authorize: \(error)")
            }
        }
    }
    
    private func deauthorize() {
        viewModel.isLoading = true
        
        mobilePaymentsSDK.authorizationManager.deauthorize {
            viewModel.isLoading = false
        }
    }
}

enum AuthorizationStateLabel {
    case warning(String)
    case error(String)
    case success(String)
    case loading(String)
}

#Preview {
    PermissionsView(viewModel: PermissionsViewModel(mobilePaymentsSDK: MockMobilePaymentsSDK(), authorizationState: .constant(.authorized)), presentingPermissionsView: .constant(false))
}
