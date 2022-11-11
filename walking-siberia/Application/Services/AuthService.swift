import Foundation

final class AuthService: NSObject {

    private let keychainService: KeychainService

    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    var userId: Int? { keychainService.currentUserId.flatMap(Int.init) }
}

extension AuthService {
    enum Status {
        case unauthorized, authorized
    }
    
    var authStatus: AuthService.Status {
        guard keychainService.token != nil && userId != nil else { return .unauthorized }
        
        return .authorized
    }
}

extension AuthService {
    
    static let statusChangedNotifiaction = Foundation.Notification.Name("AuthService.statusChanged")

    func authorize(with token: String, currentUserId: Int, withNotification: Bool) {
        keychainService.token = token
        keychainService.currentUserId = "\(currentUserId)"
        updateApi()
        
        if withNotification {
            NotificationCenter.default.post(name: AuthService.statusChangedNotifiaction, object: self)
        }
    }
    
    func updateApi() {
        APIConfig.basePath = Constants.basePath
        APIConfig.customHeaders["Authorization"] = "Bearer \(KeychainService().token ?? "")"
        APIConfig.customHeaders["User-Agent"] = Constants.userAgent
    }

    func deauthorize() {
        if keychainService.token != nil {
            keychainService.token = nil
            keychainService.currentUserId = nil
        }
        NotificationCenter.default.post(name: AuthService.statusChangedNotifiaction, object: self)
    }
}
