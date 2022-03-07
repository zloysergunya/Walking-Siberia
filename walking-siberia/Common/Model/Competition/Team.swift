import Foundation

struct Team: Codable {
    let id: Int
    let competitionId: Int
    let name: String
    let status: Int
    let statusLabel: String
    let type: Int
    let typeLabel: String
    let ownerId: Int
    let users: [Participant]
    let createAt: String
    let isJoined: Bool
}

struct Participant: Codable {
    var userId: Int
    var teamId: Int
    var createdAt: String
    var user: User
}
