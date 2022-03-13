import Foundation

struct Competition: Codable {
    let id: Int
    let name: String
    let description: String
    let status: Int
    let statusLabel: String
    let fromDate: String
    let toDate: String
    let partners: [Partner]
    let teams: [Team]
    let countTeams: Int
    let isClosed: Bool
    let isJoined: Bool
}
