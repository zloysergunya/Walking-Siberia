import Foundation

struct TeamCreateRequest: Codable {
    let name: String
    let status: Int
    let userIds: [Int]
}
