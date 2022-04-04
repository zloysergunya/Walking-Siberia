import UIKit
import UserNotifications
import FirebaseMessaging

protocol NotificationsAccessServiceInput: AnyObject {
    func requestAccess()
}

protocol NotificationsAccessServiceOutput: AnyObject {
    func successRequest(granted: Bool)
    func didReceiveRegistrationToken(token: String)
    func failureRequest(error: Error)
}

enum NotificationTopic: String {
    case route, info, competition
}

class NotificationsAccessService: NSObject {
    
    weak var output: NotificationsAccessServiceOutput?
    
    private var topics: [NotificationTopic] = []
    
    override init() {
        super.init()
        
        Messaging.messaging().delegate = self
        
        let profile = UserSettings.user?.profile
        if profile?.isNoticeInfo == true {
            topics.append(.info)
        }
        if profile?.isNoticeRoute == true {
            topics.append(.route)
        }
        if profile?.isNoticeCompetition == true {
            topics.append(.competition)
        }
        
        topics.forEach({ Self.subscribe(toTopic: $0) })
    }
    
    static func subscribe(toTopic topic: NotificationTopic) {
        Messaging.messaging().subscribe(toTopic: topic.rawValue) { error in
            if let error = error {
                log.error(error.localizedDescription)
            } else {
                log.verbose("Subscribed to \(topic) topic")
            }
        }
    }
    
    static func unsubscribe(fromTopic topic: NotificationTopic) {
        Messaging.messaging().unsubscribe(fromTopic: topic.rawValue) { error in
            if let error = error {
                log.error(error.localizedDescription)
            } else {
                log.verbose("Unsubscribed to \(topic) topic")
            }
        }
    }
    
}

// MARK: - NotificationsAccessServiceInput
extension NotificationsAccessService: NotificationsAccessServiceInput {
    
    func requestAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                log.error("Notifications requestAuthorization failed: \(error)")
                DispatchQueue.main.async {
                    self.output?.failureRequest(error: error)
                }
                
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    self.output?.successRequest(granted: granted)
                }
            }
        }
    }
    
}

// MARK: - MessagingDelegate
extension NotificationsAccessService: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        log.info("Firebase registration token: \(fcmToken ?? "EMPTY")")
        guard let token = fcmToken else {
            return
        }
        
        output?.didReceiveRegistrationToken(token: token)
    }
    
}
