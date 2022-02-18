import Foundation

struct ProfileUpdateRequest: Codable {
    let lastName: String
    let firstName: String
    let city: String
    let birthDay: String
    let email: String
    let type: Int
    let aboutMe: String?
    let telegram: String?
    let instagram: String?
    let vkontakte: String?
    let odnoklassniki: String?
    let height: Int?
    let weight: Int?
}
