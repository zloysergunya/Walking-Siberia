import Foundation

struct Notification: Codable, Equatable {
    let id: Int
    let type: String
    let title: String
    let message: String
    let date: String
    let extra: NotificationExtra
    var isViewed: Bool
}
