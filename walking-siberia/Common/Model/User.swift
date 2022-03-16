import Foundation

struct User: Codable {
    let userId: Int
    let phone: String
    let email: String?
    let type: Int
    let typeLabel: String
    let deviceId: String?
    var profile: Profile
    let isFillProfile: Bool
}

extension User: Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userId == rhs.userId
        && lhs.phone == rhs.phone
        && lhs.email == rhs.email
        && lhs.type == rhs.type
        && lhs.deviceId == rhs.deviceId
        && lhs.profile == rhs.profile
    }
    
}
