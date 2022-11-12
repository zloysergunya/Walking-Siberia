import Foundation

struct Profile: Codable, Equatable {
    var firstName: String
    var lastName: String
    let city: String
    let birthDate: String?
    let aboutMe: String?
    let height: Double?
    let weight: Double?
    let telegram: String?
    let instagram: String?
    let vkontakte: String?
    let odnoklassniki: String?
    var avatar: String?
    var isNoticeRoute: Bool
    var isNoticeInfo: Bool
    var isNoticeCompetition: Bool
}
