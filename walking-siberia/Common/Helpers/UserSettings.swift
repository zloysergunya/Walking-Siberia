import Foundation

@objc class UserSettings: NSObject {

    static let defaults = UserDefaults.standard

    fileprivate enum Keys: String {
        case user
        case pets
        case petAnimations
        case userReady
        case isLaunchedBefore
        case lastSendActivityDate
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
    
    static var lastSendActivityDate: Date? {
        get {
            return defaults.object(forKey: Keys.lastSendActivityDate.rawValue) as? Date
        }
        set {
            defaults.set(newValue, forKey: Keys.lastSendActivityDate.rawValue)
        }
    }
    
    @objc static func clear() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
}
