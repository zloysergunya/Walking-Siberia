import Foundation

struct CompetitionId: Codable, Equatable {
    let id: Int
}

struct Team: Codable {
    let id: Int
    let place: Int?
    let competitionIDs: [CompetitionId]?
    let name: String
    let status: Int
    let statusLabel: String
    let state: Int
    let stateLabel: String
    let isDisabled: Bool
    let typeLabel: String
    let ownerId: Int
    let userCount: Int?
    let avatar: String?
    let createAt: String
    var isClosed: Bool
    var isJoined: Bool
    let achievements: [Achievement]?
    let statistics: ParticipantStatistics?
}

extension Team: Equatable {
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id
        && lhs.competitionIDs == rhs.competitionIDs
        && lhs.isJoined == rhs.isJoined
        && lhs.status == rhs.status
        && lhs.isDisabled == rhs.isDisabled
        && lhs.isClosed == rhs.isClosed
        && lhs.isJoined == rhs.isJoined
        && lhs.avatar == rhs.avatar
        && lhs.userCount == rhs.userCount
    }
    
}
