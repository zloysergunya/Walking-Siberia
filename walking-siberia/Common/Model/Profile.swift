import Foundation

struct Profile: Codable, Equatable {
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
    var avatar: String?
    var isNoticeRoute: Bool
    var isNoticeInfo: Bool
    var isNoticeCompetition: Bool
}
