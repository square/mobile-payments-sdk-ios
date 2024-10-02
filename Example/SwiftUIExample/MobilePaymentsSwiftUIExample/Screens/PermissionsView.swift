import SwiftUI

struct PermissionsView: View {

    @ObservedObject var viewModel: PermissionsViewModel

    var body: some View {
        HStack {
            VStack(alignment: .center) {
                Text("MobilePaymentsSDK Permissions")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                ScrollView {
                    // Bluetooth
                    VStack { // Align text and buttons to the leading edge
                        Button(action: requestBluetooth) {
                            Text("Request Bluetooth")
                        }
                        Text("Square uses Bluetooth to connect and communicate with Square readers and compatible accessories. You should ask for this permission if you are using readers that connect via Bluetooth.")
                    }
                    .padding()

                    // Location
                    VStack {
                        Button(action: requestLocation) {
                            Text("Request Location")
                        }
                        Text("Square needs to know where transactions take place to reduce risk and minimize payment disputes.")
                    }
                    .padding()

                    // Microphone
                    VStack {
                        Button(action: requestMicrophone) {
                            Text("Request Microphone")
                        }
                        Text("Some Square readers use the microphone to communicate payment card data to your device. You should ask for this permission if you are using those types of readers.")
                    }
                    .padding()
                }
            }
            .font(.title3)
            .buttonStyle(AppButton())
            .foregroundStyle(.white)
            .padding()
        }
        .background(.teal)
    }

    // MARK: - Actions

    private func requestBluetooth() {
        viewModel.requestBluetooth()
    }

    private func requestLocation() {
        viewModel.requestLocation()
    }

    private func requestMicrophone() {
        viewModel.requestMicrophone()
    }
}

#Preview {
    PermissionsView(viewModel: PermissionsViewModel())
}
