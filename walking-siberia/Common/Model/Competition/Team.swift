import Foundation

struct Team: Codable {
    let id: Int
    let competitionId: Int
    let name: String
    let status: Int
    let statusLabel: String
    let isDisabled: Bool?
    let typeLabel: String
    let ownerId: Int
    let createAt: String
    var isClosed: Bool
    var isJoined: Bool
    let statistics: ParticipantStatistics
    let avatar: String?
    let userCount: Int
}

extension Team: Equatable {
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id
        && lhs.isJoined == rhs.isJoined
        && lhs.status == rhs.status
        && lhs.isDisabled == rhs.isDisabled
        && lhs.isClosed == rhs.isClosed
        && lhs.isJoined == rhs.isJoined
        && lhs.avatar == rhs.avatar
        && lhs.userCount == rhs.userCount
    }
    
}
