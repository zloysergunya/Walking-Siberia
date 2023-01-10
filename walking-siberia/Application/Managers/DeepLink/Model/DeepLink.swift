import Foundation

enum DeepLink {
    case video(Int)
    case route(Int)
    case article(Int)
    case competition(Int)
    case friend(Int)
    case reward(Int)
    
    init(id: Int, type: DeepLinkType) {
        switch type {
        case .video:
            self = .video(id)
        case .route:
            self = .route(id)
        case .article:
            self = .article(id)
        case .competition:
            self = .competition(id)
        case .friend:
            self = .friend(id)
        case .reward:
            self = .reward(id)
        }
    }
}

enum DeepLinkType: String {
    case video
    case route
    case article
    case competition
    case friend
    case reward
}
