import Foundation

struct NotificationListRequest: Codable {
    let filter: String
    let limit: Int
    let page: Int
}
