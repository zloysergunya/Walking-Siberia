import KeychainAccess

@dynamicMemberLookup
final class KeychainService: NSObject {

    struct KeychainKeys {
        let token = "token"
        let currentUserId = "currentUserId"
    }

    private let storage: Keychain

    init(storage: Keychain = .init(service: Constants.bundleIdentifier)) {
        self.storage = storage
        super.init()
        
        cleanIfNeeded()
    }

    func cleanIfNeeded() {
        guard !UserSettings.isLaunchedBefore else { return }

        try? storage.removeAll()
        UserSettings.isLaunchedBefore = true
    }
}

extension KeychainService {

    private static let keys = KeychainKeys()
    subscript(dynamicMember keyPath: KeyPath<KeychainKeys, String>) -> String? {
        get {
            let key = Self.keys[keyPath: keyPath]
            return storage[key]
        }
        set {
            let key = Self.keys[keyPath: keyPath]
            storage[key] = newValue
        }
    }
}
