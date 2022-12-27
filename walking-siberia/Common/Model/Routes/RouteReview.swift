import Foundation

struct RouteReview: Codable, Equatable {
    let routeId: Int
    let text: String
    let username: String
    let createdAt: Date
}
