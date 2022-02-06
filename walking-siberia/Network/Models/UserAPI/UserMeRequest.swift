import Foundation

struct UserMeRequest: Codable {
    var age: Int = 0
    var gender: String = ""
    var height: Int = 0
    var name: String = ""
    var stepsCount: Int = 0
    var username: String = ""
    var weight: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case age
        case gender
        case height
        case name
        case stepsCount = "steps_count"
        case username
        case weight
    }
    
}
