import Foundation

struct Profile: Codable {
    let firstName: String
    let lastName: String
    let city: String
    let birthDate: String?
    let aboutMe: String?
    let height: Int?
    let weight: Int?
    let telegram: String?
    let instagram: String?
    let vkontakte: String?
    let odnoklassniki: String?
    let avatar: String?
}

extension Profile: Equatable {
    
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.firstName == rhs.firstName
        && lhs.lastName == rhs.lastName
        && lhs.city == rhs.city
        && lhs.birthDate == rhs.birthDate
        && lhs.aboutMe == rhs.aboutMe
        && lhs.height == rhs.height
        && lhs.weight == rhs.weight
        && lhs.telegram == rhs.telegram
        && lhs.instagram == rhs.instagram
        && lhs.vkontakte == rhs.vkontakte
        && lhs.odnoklassniki == rhs.odnoklassniki
        && lhs.avatar == rhs.avatar
    }
    
}
