import AVFoundation
import CoreBluetooth
import CoreLocation
import SwiftUI

@Observable class PermissionsViewModel: NSObject {
    
    var isBluetoothPermissionGranted: Bool = false
    var isLocationPermissionGranted: Bool = false
    var isMicrophonePermissionGranted: Bool = false
    var allPermissionsGranted: Bool {
        isBluetoothPermissionGranted && isLocationPermissionGranted && isMicrophonePermissionGranted
    }

    @ObservationIgnored private var bluetoothManager: CBCentralManager?
    @ObservationIgnored private var locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        refreshAllPermissionsStatus()
    }
    
    // MARK: - Request Permissions
    
    func requestBluetooth() {
        switch CBManager.authorization {
        case .notDetermined:
            bluetoothManager = CBCentralManager(delegate: self, queue: .main)
        case .denied, .restricted:
            openAppSettings()
        case .allowedAlways:
            refreshBluetoothPermissionStatus()
        @unknown default:
            fatalError("Invalid Bluetooth permission status")
        }
    }
    
    func requestLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            openAppSettings()
        case .authorizedAlways, .authorizedWhenInUse:
            refreshLocationManagerStatus()
        @unknown default:
            fatalError("Invalid location permission status")
        }
    }
    
    func requestMicrophone() {
        switch AVAudioApplication.shared.recordPermission {
        case .undetermined:
            AVCaptureDevice.requestAccess(for: .audio) { [weak self] _ in
                Task { @MainActor [weak self] in self?.refreshMicrophonePermission() }
            }
        case .denied:
            self.openAppSettings()
        default:
            return
        }
    }
    
    // MARK: - Private Methods
    
    func refreshAllPermissionsStatus() {
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
        switch AVAudioApplication.shared.recordPermission {
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
