import Foundation

struct TeamDeleteUserRequest: Codable {
    let teamId: Int
    let userId: Int
}
