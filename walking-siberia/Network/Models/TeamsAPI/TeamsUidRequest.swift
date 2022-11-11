import Foundation

struct TeamsUidRequest: Codable {
    let uid: Int
    let name: String
    let disabled: Bool
    let limit: Int
    let page: Int
}
