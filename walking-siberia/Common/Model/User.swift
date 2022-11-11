import Foundation

struct User: Codable {
    let userId: Int
    let phone: String?
    let email: String?
    let isDisabled: Bool?
    let type: Int
    let typeLabel: String
    let deviceId: String?
    var profile: Profile
    var isFriend: Bool?
    let isFillProfile: Bool
    let dailyStats: Average
    let inTeam: Bool?
}

extension User: Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.userId == rhs.userId
        && lhs.phone == rhs.phone
        && lhs.email == rhs.email
        && lhs.isDisabled == rhs.isDisabled
        && lhs.type == rhs.type
        && lhs.typeLabel == rhs.typeLabel
        && lhs.deviceId == rhs.deviceId
        && lhs.profile == rhs.profile
        && lhs.isFriend == rhs.isFriend
        && lhs.inTeam == rhs.inTeam
    }
    
}
