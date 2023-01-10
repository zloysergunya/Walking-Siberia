import UIKit

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
        case .video: return R.image.videoType20()
        case .route: return R.image.routeType20()
        case .article: return R.image.articleType20()
        case .competition: return R.image.competitionType20()
        case .friend: return R.image.friendType20()
        case .reward: return R.image.rewardType20()
        }
    }
}
