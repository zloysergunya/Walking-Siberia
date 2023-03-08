import Foundation

struct ExpertQuestion: Codable, Equatable, Hashable {
    let id: Int
    let expertId: Int
    let question: String
    let answer: String
}
