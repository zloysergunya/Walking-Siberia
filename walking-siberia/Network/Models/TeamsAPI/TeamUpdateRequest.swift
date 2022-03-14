import Foundation

struct TeamUpdateRequest: Codable {
    let teamId: Int
    let name: String
    let status: Int
    let userIds: [Int]
}
