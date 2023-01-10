import Foundation

class DeepLinkNotificationParser {
    
    init() {}
    
    func parse(_ userInfo: [AnyHashable: Any]) -> DeepLink? {
//        guard
//            let data = userInfo["data"] as? [String: Any],
//            let type = data["type"] as? String,
//            let action = DeepLinkType(rawValue: type)
//        else { return nil }
//
//        switch action {
//        case .message, .call, .chat:
//            guard
//                let body = data["body"] as? [String: Any],
//                let chatId = body["chat_id"] as? Int64
//            else { return nil }
//
//            return DeepLink.chatId(chatId: chatId)
//        case .friend, .following, .user:
//            guard
//                let body = data["body"] as? [String: Any],
//                let userId = body["user_id"] as? Int64
//            else { return nil }
//
//            return DeepLink.user(userId: userId)
//        case .activity:
//            return DeepLink.activity
//
//        case .inviteContact:
//            return DeepLink.inviteContact
//
//        case .coins:
//            return DeepLink.coins
//
//        case .store:
//            return DeepLink.store
//
//        case .dailyAward:
//            guard
//                let body = data["body"] as? [String: Any],
//                let userAwardId = body["user_award_id"] as? Int64
//            else { return nil }
//
//            return DeepLink.dailyAward(userAwardId: userAwardId)
//
//        }
        return nil
    }
    
    func parse(_ userActivity: NSUserActivity) -> DeepLink? {
        if let userInfo = userActivity.userInfo {
            return parse(userInfo)
        }
        
        return nil
    }
    
}
