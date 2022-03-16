import Foundation

struct FriendsRequest: Codable {
    let filter: String
    let limit: Int
    let page: Int
}
