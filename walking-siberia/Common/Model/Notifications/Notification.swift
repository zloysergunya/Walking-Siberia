import Foundation
import UIKit

struct Notification: Codable, Equatable {
    let id: Int
    let type: String
    let title: String
    let message: String
    let date: String
    let extra: NotificationExtra
    var isViewed: Bool
}

enum NotificationType: String {
    case video, route, article, competition, friend, reward
    
    var title: String {
        switch self {
        case .video: return "Информация"
        case .route: return "Маршруты"
        case .article: return "Информация"
        case .competition: return "Соревнования"
        case .friend: return "Друзья"
        case .reward: return "Награждения"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .video: return nil
        case .route: return R.image.routeType20()
        case .article: return nil
        case .competition: return R.image.competitionType20()
        case .friend: return nil
        case .reward: return nil
        }
    }
    
}
