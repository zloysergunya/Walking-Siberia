import Foundation

struct TeamDeleteUserRequest: Codable {
    let teamId: Int
    let teamUserId: Int
}
