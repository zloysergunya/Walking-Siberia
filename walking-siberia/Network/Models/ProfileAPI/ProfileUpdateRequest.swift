import Foundation

struct ProfileUpdateRequest: Codable {
    
    let phone: String?
    let lastName: String?
    let firstName: String?
    let city: String?
    let birthDay: String?
    let email: String?
    let isDisabled: Bool?
    let aboutMe: String?
    let telegram: String?
    let instagram: String?
    let vkontakte: String?
    let odnoklassniki: String?
    let height: Int?
    let weight: Int?
    
    init(phone: String? = nil, lastName: String? = nil, firstName: String? = nil, city: String? = nil, birthDay: String? = nil, email: String? = nil, isDisabled: Bool? = nil, aboutMe: String? = nil, telegram: String? = nil, instagram: String? = nil, vkontakte: String? = nil, odnoklassniki: String? = nil, height: Int? = nil, weight: Int? = nil) {
        self.phone = phone
        self.lastName = lastName
        self.firstName = firstName
        self.city = city
        self.birthDay = birthDay
        self.email = email
        self.isDisabled = isDisabled
        self.aboutMe = aboutMe
        self.telegram = telegram
        self.instagram = instagram
        self.vkontakte = vkontakte
        self.odnoklassniki = odnoklassniki
        self.height = height
        self.weight = weight
    }
    
}
