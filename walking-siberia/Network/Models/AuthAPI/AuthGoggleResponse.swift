import Foundation

struct AuthGoggleResponse: Codable {
    let token: String
    let user: User
    let new: Bool
}
