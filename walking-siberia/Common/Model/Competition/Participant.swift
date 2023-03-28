import Foundation

struct Participant: Codable {
    var userId: Int
    var teamId: Int
    var createdAt: String
    var user: User
    let statistics: ParticipantStatistics?
}

extension Participant: Equatable {
    
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        return lhs.teamId == rhs.teamId
        && lhs.userId == rhs.userId
        && lhs.user == rhs.user
        && lhs.statistics == rhs.statistics
    }
    
}
