import Foundation

struct TeamAddUserRequest: Codable {
    let teamId: Int
    let userId: Int
}
