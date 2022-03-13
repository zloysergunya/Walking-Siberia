import Foundation

struct Participant: Codable {
    var userId: Int
    var teamId: Int
    var createdAt: String
    var user: User
}

extension Participant: Equatable {
    
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        return lhs.teamId == rhs.teamId && lhs.userId == rhs.userId
    }
    
}
