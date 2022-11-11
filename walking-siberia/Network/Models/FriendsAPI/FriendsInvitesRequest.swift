import Foundation

struct FriendsInvitesRequest: Codable {
    let competitionId: Int
    let disabled: Bool
    let search: String
    let limit: Int
    let page: Int
}
