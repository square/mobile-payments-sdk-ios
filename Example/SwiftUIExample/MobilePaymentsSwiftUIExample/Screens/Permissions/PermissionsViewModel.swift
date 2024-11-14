import AVFoundation
import CoreBluetooth
import CoreLocation
import SquareMobilePaymentsSDK
import SwiftUI

@Observable class PermissionsViewModel: NSObject {
    
    var isBluetoothPermissionGranted: Bool = false
    var isLocationPermissionGranted: Bool = false
    var isMicrophonePermissionGranted: Bool = false
    var isLoading: Bool = false
    var authorizationFailed: Bool = false
    var authorizationState: AuthorizationState

    @ObservationIgnored private var bluetoothManager: CBCentralManager?
    @ObservationIgnored private var locationManager: CLLocationManager = CLLocationManager()
    
    let mobilePaymentsSDK: SDKManager
    
    init(mobilePaymentsSDK: SDKManager) {
        self.mobilePaymentsSDK = mobilePaymentsSDK
        self.authorizationState = mobilePaymentsSDK.authorizationManager.state
        super.init()
        
        mobilePaymentsSDK.authorizationManager.add(self)
        refreshAuthorizationState()
        
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
    
    private func refreshAuthorizationState() {
        authorizationState = mobilePaymentsSDK.authorizationManager.state
    }
    
    deinit {
        mobilePaymentsSDK.authorizationManager.remove(self)
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

// MARK: - AuthorizationStateObserver

extension PermissionsViewModel: AuthorizationStateObserver {
    func authorizationStateDidChange(_ authorizationState: AuthorizationState) {
        refreshAuthorizationState()
    }
}
