import Foundation

struct TeamsUidRequest: Codable {
    let uid: Int
    let filter: String
    let limit: Int
    let page: Int
}
