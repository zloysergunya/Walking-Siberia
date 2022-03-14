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
    var users: [Participant]
    let createAt: String
    var isClosed: Bool
    var isJoined: Bool
}

extension Team: Equatable {
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id
        && lhs.isJoined == rhs.isJoined
        && lhs.users == rhs.users
        && lhs.status == rhs.status
    }
    
}
