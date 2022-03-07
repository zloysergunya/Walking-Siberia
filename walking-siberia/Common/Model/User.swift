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
