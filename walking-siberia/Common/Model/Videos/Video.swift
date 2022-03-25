import Foundation

struct Video: Codable, Equatable {
    let id: Int
    let title: String
    let file: String
    let preview: String
    let countViews: Int
    let duration, createdAt: String
}

