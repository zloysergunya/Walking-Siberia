import Foundation

struct Route: Codable {
    let id: Int
    let name: String
    let routeDescription: String
    let km: Double
    let photos: [String]
    let photoMap: String
    let mapLink: String
    let places: [Place]
    var isLike: Bool
    var countLikes: Int
    let comments: [RouteReview]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case routeDescription = "description"
        case km
        case photos
        case photoMap
        case mapLink
        case places
        case isLike
        case countLikes
        case comments
    }
}
