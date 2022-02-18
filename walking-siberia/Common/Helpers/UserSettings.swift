import Foundation

@objc class UserSettings: NSObject {

    static let defaults = UserDefaults.standard

    fileprivate enum Keys: String {
        case token
        case user
        case pets
        case petAnimations
        case userReady
        case isLaunchedBefore
    }
    
    static var token: String? {
        get {
            return defaults.string(forKey: Keys.token.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    static var user: User? {
        get {
            return try? defaults.get(objectType: User.self, forKey: Keys.user.rawValue)
        }
        set {
            try? defaults.set(object: newValue, forKey: Keys.user.rawValue)
        }
    }
    
    static var userReady: Bool {
        get {
            return defaults.bool(forKey: Keys.userReady.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.userReady.rawValue)
        }
    }
    
    static var isLaunchedBefore: Bool {
        get {
            return defaults.bool(forKey: Keys.isLaunchedBefore.rawValue)
        }
        set {
            defaults.set(newValue, forKey: Keys.isLaunchedBefore.rawValue)
        }
    }
    
    @objc static func clear() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
}
