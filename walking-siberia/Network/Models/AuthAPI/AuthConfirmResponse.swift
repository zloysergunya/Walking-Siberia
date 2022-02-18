import Foundation

struct AuthConfirmResponse: Codable {
    let accessToken: String
    let user: User    
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user
    }
}
