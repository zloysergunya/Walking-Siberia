import Foundation

struct FriendsInvitesRequest: Codable {
    let disabled: Bool
    let search: String
    let limit: Int
    let page: Int
}
