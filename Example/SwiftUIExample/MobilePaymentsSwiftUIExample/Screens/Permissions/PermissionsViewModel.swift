import AVFoundation
import CoreBluetooth
import CoreLocation
import SquareMobilePaymentsSDK
import SwiftUI

class PermissionsViewModel: NSObject, ObservableObject {
    
    @Published var isBluetoothPermissionGranted: Bool = false
    @Published var isLocationPermissionGranted: Bool = false
    @Published var isMicrophonePermissionGranted: Bool = false
    @Published var isLoading: Bool = false
    @Published var authorizationFailed: Bool = false
    @Binding var authorizationState: AuthorizationState

    private var bluetoothManager: CBCentralManager?
    private var locationManager: CLLocationManager = CLLocationManager()
    
    let mobilePaymentsSDK: SDKManager
    
    init(mobilePaymentsSDK: SDKManager, authorizationState: Binding<AuthorizationState>) {
        self.mobilePaymentsSDK = mobilePaymentsSDK
        self._authorizationState = authorizationState
        super.init()
        
        locationManager.delegate = self
        refreshAllPermissionsStatus()
    }
    
    // MARK: - Request Permissions
    
    func requestBluetooth() {
        guard CBManager.authorization == .notDetermined else { return }
        bluetoothManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func requestLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            openAppSettings()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location services have already been authorized.")
        @unknown default:
            fatalError("Invalid location permission status")
        }
    }
    
    func requestMicrophone() {
        AVCaptureDevice.requestAccess(for: .audio) { [weak self] _ in
            self?.refreshMicrophonePermission()
        }
    }
    
    // MARK: - Private Methods
    
    private func refreshAllPermissionsStatus() {
        refreshBluetoothPermissionStatus()
        refreshLocationManagerStatus()
        refreshMicrophonePermission()
    }
    
    private func refreshBluetoothPermissionStatus() {
        switch CBManager.authorization {
        case .allowedAlways:
            isBluetoothPermissionGranted = true
        default:
            isBluetoothPermissionGranted = false
        }
    }
    
    private func refreshLocationManagerStatus() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationPermissionGranted = true
        default:
            isLocationPermissionGranted = false
        }
    }
    
    private func refreshMicrophonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            isMicrophonePermissionGranted = true
        default:
            isMicrophonePermissionGranted = false
        }
    }
    
    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:]) { _ in }
        }
    }
}

// MARK: - CBCentralManagerDelegate

extension PermissionsViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        refreshBluetoothPermissionStatus()
    }
}

// MARK: - CLLocationManagerDelegate
extension PermissionsViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        refreshLocationManagerStatus()
    }
}


