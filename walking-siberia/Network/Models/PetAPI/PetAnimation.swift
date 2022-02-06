import Foundation

struct PetAnimation: Codable {
    let id: Int
    let state: Int
    let animations: PetAnimationTypes
}

struct PetAnimationTypes: Codable {
    let base: String
    let blink: String?
    let happy: String?
    let leftRight: String?
    let registration: String?
    let scratch: String?
    let tap: String
    let yawn: String?
    let heart: String?
    let sleeping: String?
    let thinking: String?
    let tears : String?
    let moveTears: String?

    enum CodingKeys: String, CodingKey {
        case base
        case blink
        case happy
        case leftRight = "left_right"
        case registration
        case scratch
        case tap
        case yawn
        case heart
        case sleeping
        case thinking
        case tears
        case moveTears = "move_tears"
    }
    
}
