import Foundation

enum AuthType: Codable {
    case phone, apple, google
    
    var description: String {
        switch self {
        case .phone: return "Номер телефона"
        case .apple: return "Apple"
        case .google: return "Google"
        }
    }
    
}

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
    
    static var authType: AuthType? {
        get {
            return try? defaults.get(objectType: AuthType.self, forKey: #function)
        }
        set {
            try? defaults.set(object: newValue, forKey: #function)
        }
    }
    
    static var routes: [Route]? {
        get {
            return try? defaults.get(objectType: [Route].self, forKey: #function)
        }
        set {
            try? defaults.set(object: newValue, forKey: #function)
        }
    }
    
    static var competitions: [Competition]? {
        get {
            return try? defaults.get(objectType: [Competition].self, forKey: #function)
        }
        set {
            try? defaults.set(object: newValue, forKey: #function)
        }
    }
    
    static var trainers: [Trainer]? {
        get {
            return try? defaults.get(objectType: [Trainer].self, forKey: #function)
        }
        set {
            try? defaults.set(object: newValue, forKey: #function)
        }
    }
    
    static var experts: [Expert]? {
        get {
            return try? defaults.get(objectType: [Expert].self, forKey: #function)
        }
        set {
            try? defaults.set(object: newValue, forKey: #function)
        }
    }
    
    static var expertsQuestions: Set<ExpertQuestion>? {
        get {
            return try? defaults.get(objectType: Set<ExpertQuestion>.self, forKey: #function)
        }
        set {
            try? defaults.set(object: newValue, forKey: #function)
        }
    }
    
    static var statistic: Statistic? {
        get {
            return try? defaults.get(objectType: Statistic.self, forKey: #function)
        }
        set {
            try? defaults.set(object: newValue, forKey: #function)
        }
    }
    
    static var isDev: Bool {
        get {
            return defaults.bool(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    @objc static func clear() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
}
