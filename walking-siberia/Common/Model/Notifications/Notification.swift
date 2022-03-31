import Foundation

struct Notification: Codable, Equatable {
    let id: Int
    let type: String
    let message: String
    let date: String
    let extra: NotificationExtra
    let isViewed: Bool
}
