import Foundation

struct Article: Codable, Equatable {
    let id: Int
    let title: String
    let content: String
    let publishedAt: String
    let countViews: Int
    let link: String?
    let image: String
}
