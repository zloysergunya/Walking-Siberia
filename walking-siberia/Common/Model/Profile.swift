import Foundation

struct Profile: Codable {
    let firstName: String
    let lastName: String
    let city: String
    let birthDate: String?
    let aboutMe: String
    let height: Int
    let weight: Int
    let telegram: String
    let instagram: String
    let vkontakte: String
    let odnoklassniki: String
    let avatar: String?
}
