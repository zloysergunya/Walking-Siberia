import Foundation

struct UsersRequest: Codable {
    let filter: String
    let search: String
    let limit: Int
    let page: Int
}
