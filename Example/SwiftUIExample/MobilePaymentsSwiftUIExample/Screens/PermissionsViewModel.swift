import AVFoundation
import CoreBluetooth
import CoreLocation

class PermissionsViewModel: NSObject, ObservableObject {

    private var bluetoothManager: CBCentralManager!
    private var locationManager: CLLocationManager!

    func requestBluetooth() {
        if bluetoothManager != nil { return }
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    }

    func requestLocation() {
        if locationManager != nil { return }
        locationManager = CLLocationManager()
        switch locationManager.authorizationStatus {
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

    func requestMicrophone() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            print("\(#function) - \(granted)")
        }
    }
}

// MARK: - CBCentralManagerDelegate

extension PermissionsViewModel: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Bluetooth Permission: \(prettyPrintCentralManagerState(central.state))")
    }

    func prettyPrintCentralManagerState(_ state: CBManagerState) -> String {
        switch state {
          case .unknown:
            "Unknown"
          case .resetting:
            "Resetting"
          case .unsupported:
            "Unsupported"
          case .unauthorized:
            "Unauthorized"
          case .poweredOff:
            "Powered Off"
          case .poweredOn:
            "Powered On"
          @unknown default:
            "Unknown State"
          }
    }
}
