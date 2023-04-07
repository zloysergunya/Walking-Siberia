import Foundation

struct Expert: Codable, Equatable {
    let id: Int
    let firstName: String
    let lastName: String
    let phone: String?
    let specialization: String?
    let description: String
    let photo: String?
}
