import Foundation

struct User: Codable {
    let userID: Int
    let phone: String
    let email: String?
    let type: Int
    let typeLabel: String
    let deviceID: String?
    let profile: Profile
    let isFillProfile: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case phone
        case email
        case type
        case typeLabel
        case deviceID = "deviceId"
        case profile
        case isFillProfile
    }
}
