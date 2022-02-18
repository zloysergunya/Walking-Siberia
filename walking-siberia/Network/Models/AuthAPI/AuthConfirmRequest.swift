import Foundation

struct AuthConfirmRequest: Codable {
    let phone: String
    let code: String
}
