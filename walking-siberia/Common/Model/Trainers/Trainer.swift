import Foundation

struct Trainer: Codable, Equatable {
    let id: Int
    let firstName: String
    let lastName: String
    let phone: String
    let description: String
    let placeOfTraining: String
    let trainingTime: String
    let photo: String?
}
