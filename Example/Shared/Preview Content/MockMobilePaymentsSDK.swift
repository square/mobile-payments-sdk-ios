import SquareMobilePaymentsSDK

class MockMobilePaymentsSDK: NSObject, SDKManager {
    let authorizationManager: AuthorizationManager
    let paymentManager: PaymentManager
    let readCardInfoManager: ReadCardInfoManager
    let readerManager: ReaderManager
    let settingsManager: SettingsManager

    init(
        authorizationManager: AuthorizationManager = MockAuthorizationManager(),
        paymentManager: PaymentManager = MockPaymentManager(),
        readCardInfoManager: ReadCardInfoManager = MockReadCardInfoManager(),
        readerManager: ReaderManager = MockReaderManager(),
        settingsManager: SettingsManager = MockSettingsManager()
    ) {
        self.authorizationManager = authorizationManager
        self.paymentManager = paymentManager
        self.readCardInfoManager = readCardInfoManager
        self.readerManager = readerManager
        self.settingsManager = settingsManager
    }
}

class MockAuthorizationManager: NSObject, AuthorizationManager {
    let location: Location?
    var state: AuthorizationState

    init(
        location: Location? = MockLocation(),
        state: AuthorizationState = .authorized
    ) {
        self.location = location
        self.state = state
    }

    func authorize(withAccessToken accessToken: String, locationID: String, completion: @escaping (Error?) -> Void) { }
    func deauthorize(completion: @escaping () -> Void) { }
    func add(_ authorizationStateObserver: AuthorizationStateObserver) { }
    func remove(_ authorizationStateObserver: AuthorizationStateObserver) { }
}

class MockLocation: NSObject, Location {
    let id: String
    let name: String
    let mcc: String
    let currency: Currency

    init(
        id: String = "1",
        name: String = "My Location",
        mcc: String = "mcc",
        currency: Currency = .USD
    ) {
        self.id = id
        self.name = name
        self.mcc = mcc
        self.currency = currency
    }
}

class MockPaymentManager: NSObject, PaymentManager {
    var availableCardInputMethods: CardInputMethods
    let offlinePaymentQueue: OfflinePaymentQueue

    init(
        availableCardInputMethods: CardInputMethods = .init([.chip, .contactless, .swipe]),
        offlinePaymentQueue: OfflinePaymentQueue = MockOfflinePaymentQueue()
    ) {
        self.availableCardInputMethods = availableCardInputMethods
        self.offlinePaymentQueue = offlinePaymentQueue
    }

    func startPayment(
        _ paymentParameters: PaymentParameters,
        promptParameters: PromptParameters,
        from viewController: UIViewController,
        delegate: PaymentManagerDelegate
    ) -> PaymentHandle? { nil }
    func add(_ availableCardInputMethodsObserver: AvailableCardInputMethodsObserver) { }
    func remove(_ availableCardInputMethodsObserver: AvailableCardInputMethodsObserver) { }
}

class MockOfflinePaymentQueue: NSObject, OfflinePaymentQueue {
    func getTotalStoredPaymentsAmount(completion: @escaping (MoneyAmount?, Error?) -> Void) { }
    func getPayments(_ completion: @escaping ([OfflinePayment], Error?) -> Void) { }
}

class MockReadCardInfoManager: NSObject, ReadCardInfoManager {
    func prepareToReadCardInfoOnce(withStoreSwipedCard storeSwipedCard: Bool, shouldReadPreInsertedCard: Bool) { }
    func cancelReadingCardInfo() { }
    func add(_ readCardInfoObserver: ReadCardInfoObserver) { }
    func remove(_ readCardInfoObserver: ReadCardInfoObserver) { }
}

class MockReaderManager: NSObject, ReaderManager {
    var tapToPaySettings: TapToPaySettings
    
    var readers: [ReaderInfo]
    var isPairingInProgress: Bool

    init(
        readers: [ReaderInfo] = [MockReaderInfo()],
        isPairingInProgress: Bool = false,
        tapToPaySettings: TapToPaySettings = MockTapToPaySettings()
    ) {
        self.readers = readers
        self.isPairingInProgress = isPairingInProgress
        self.tapToPaySettings = tapToPaySettings
    }

    func startPairing(with delegate: ReaderPairingDelegate) -> PairingHandle? { nil }
    func linkTapToPayReader(completion: @escaping (Error?) -> Void) { }
    func relinkTapToPayReader(completion: @escaping (Error?) -> Void) { }
    func isTapToPayReaderLinked(completion: @escaping (Bool, Error?) -> Void) { }
    func isTapToPayReaderSupported() -> Bool { true }
    func forget(_ readerInfo: ReaderInfo) { }
    func blink(_ readerInfo: ReaderInfo) { }
    func retryConnection(_ readerInfo: ReaderInfo) { }
    func add(_ readerObserver: ReaderObserver) { }
    func remove(_ readerObserver: ReaderObserver) { }
}

class MockTapToPaySettings: NSObject, TapToPaySettings {
    var isDeviceCapable: Bool
    
    init(isDeviceCapable: Bool = false) {
        self.isDeviceCapable = isDeviceCapable
    }
    
    func isAppleAccountLinked(completion: @escaping (Bool, (any Error)?) -> Void) { }
    func linkAppleAccount(completion: @escaping ((any Error)?) -> Void) { }
    func relinkAppleAccount(completion: @escaping ((any Error)?) -> Void) { }
}

class MockReaderInfo: NSObject, ReaderInfo {
    var id: UInt
    var name: String
    var serialNumber: String?
    var model: ReaderModel
    var supportedInputMethods: CardInputMethods
    var connectionInfo: ReaderConnectionInfo
    var firmwareInfo: ReaderFirmwareInfo?
    var state: ReaderState
    var batteryStatus: ReaderBatteryStatus?
    var isBlinkable: Bool
    var isForgettable: Bool
    var isConnectionRetryable: Bool
    var cardInsertionStatus: CardInsertionStatus

    init(
        id: UInt = 1,
        name: String = "My Reader",
        serialNumber: String? = nil,
        model: ReaderModel = .contactlessAndChip,
        supportedInputMethods: CardInputMethods = .init([.contactless, .chip]),
        connectionInfo: ReaderConnectionInfo = MockReaderConnectionInfo(),
        firmwareInfo: ReaderFirmwareInfo? = nil,
        state: ReaderState = .ready,
        batteryStatus: ReaderBatteryStatus? = nil,
        isBlinkable: Bool = true,
        isForgettable: Bool = true,
        isConnectionRetryable: Bool = false,
        cardInsertionStatus: CardInsertionStatus = .notInserted
    ) {
        self.id = id
        self.name = name
        self.serialNumber = serialNumber
        self.model = model
        self.supportedInputMethods = supportedInputMethods
        self.connectionInfo = connectionInfo
        self.firmwareInfo = firmwareInfo
        self.state = state
        self.batteryStatus = batteryStatus
        self.isBlinkable = isBlinkable
        self.isForgettable = isForgettable
        self.isConnectionRetryable = isConnectionRetryable
        self.cardInsertionStatus = cardInsertionStatus
    }
}

class MockReaderConnectionInfo: NSObject, ReaderConnectionInfo {
    var state: ReaderConnectionState
    var failureInfo: ReaderConnectionFailureInfo?

    init(
        state: ReaderConnectionState = .connected,
        failureInfo: ReaderConnectionFailureInfo? = nil
    ) {
        self.state = state
        self.failureInfo = failureInfo
    }
}

class MockSettingsManager: NSObject, SettingsManager {
    let sdkSettings: SDKSettings
    let paymentSettings: PaymentSettings

    init(
        sdkSettings: SDKSettings = MockSDKSettings(),
        paymentSettings: PaymentSettings = MockPaymentSettings()
    ) {
        self.sdkSettings = sdkSettings
        self.paymentSettings = paymentSettings
    }

    func presentSettings(
        with viewController: UIViewController,
        completion: @escaping (Error?) -> Void
    ) { }
}

class MockSDKSettings: NSObject, SDKSettings {
    let environment: Environment
    let version: String

    init(
        environment: Environment = .sandbox,
        version: String = "1"
    ) {
        self.environment = environment
        self.version = version
    }
}

class MockPaymentSettings: NSObject, PaymentSettings {
    let isOfflineProcessingAllowed: Bool
    let offlineTransactionAmountLimit: MoneyAmount?
    let offlineTotalStoredAmountLimit: MoneyAmount?

    init(
        isOfflineProcessingAllowed: Bool = true,
        offlineTransactionAmountLimit: MoneyAmount? = nil,
        offlineTotalStoredAmountLimit: MoneyAmount? = nil
    ) {
        self.isOfflineProcessingAllowed = isOfflineProcessingAllowed
        self.offlineTransactionAmountLimit = offlineTransactionAmountLimit
        self.offlineTotalStoredAmountLimit = offlineTotalStoredAmountLimit
    }
}
