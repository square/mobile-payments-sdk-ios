//
//  PermissionsView.swift
//  MobilePaymentsExample
//
//  Created by Brandon Jenniges on 6/11/24.
//

import AVFoundation
import CoreBluetooth
import CoreLocation
import SwiftUI

struct PermissionsView: View {

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

    private func requestBluetooth() {
        let _ = CBCentralManager()
    }

    private func requestLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            CLLocationManager().requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Show UI directing the user to the iOS Settings app")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location services have already been authorized.")
        @unknown default:
            fatalError()
        }
    }

    private func requestMicrophone() { 
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            print("\(#function) - \(granted)")
        }
    }
}

#Preview {
    PermissionsView()
}
