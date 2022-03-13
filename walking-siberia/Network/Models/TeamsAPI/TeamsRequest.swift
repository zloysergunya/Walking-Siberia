import Foundation

struct TeamsRequest: Codable {
    let filter: String
    let limit: Int
    let page: Int
}
