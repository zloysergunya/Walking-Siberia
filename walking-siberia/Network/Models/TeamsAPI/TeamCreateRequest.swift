import Foundation

struct TeamCreateRequest: Codable {
    let competitionId: Int
    let name: String
    let status: Int
    let userIds: [Int]
}
