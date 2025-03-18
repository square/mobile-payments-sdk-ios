import Foundation

/// `IdempotencyKeyStorage` is a class that manages the association between business-logic specific identifiers (such as sales IDs, ticket IDs, order IDs, check numbers, etc.) and uniquely generated idempotency keys.
///
/// An idempotency key guarantees the uniqueness of each payment across the system, allowing for the following:
/// 1. Persistence of keys across app sessions to safeguard against scenarios such as crashes or unexpected app termination.
/// 2. Support for payment retries without risk of duplicating the transaction.
///
/// For more information about how idempotency works within the Square ecosystem, refer to the [Square Developer Documentation on Idempotency](https://developer.squareup.com/docs/build-basics/common-api-patterns/idempotency).
class IdempotencyKeyStorage<Identifier: Hashable & Codable> where Identifier: Codable {
    typealias IdempotencyKey = String

    // MARK: - Properties

    private let userDefaultsKey = "IdempotencyKeyStorage"

    private var storage: [Identifier: IdempotencyKey] = [:] {
        didSet {
            saveToUserDefaults()
        }
    }

    // MARK: - Initializers

    init() {
        storage = loadFromUserDefaults() ?? [:]
    }

    // MARK: - Methods

    func store(id: Identifier, idempotencyKey: IdempotencyKey) {
        storage[id] = idempotencyKey
    }

    func delete(id: Identifier) {
        storage.removeValue(forKey: id)
    }

    func get(id: Identifier) -> IdempotencyKey? {
        return storage[id]
    }
}

// MARK: - Private Methods

extension IdempotencyKeyStorage {
    private func loadFromUserDefaults() -> [Identifier: IdempotencyKey]? {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            return try? JSONDecoder().decode([Identifier: IdempotencyKey].self, from: data)
        }
        return nil
    }

    private func saveToUserDefaults() {
        if let data = try? JSONEncoder().encode(storage) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
