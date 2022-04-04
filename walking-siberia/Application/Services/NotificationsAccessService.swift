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

class NotificationsAccessService: NSObject {
    
    weak var output: NotificationsAccessServiceOutput?
    
    private let topics = ["route", "info", "competition"]
    
    override init() {
        super.init()
        
        Messaging.messaging().delegate = self
        
        topics.forEach({ subscribe(toTopic: $0) })
    }
    
    private func subscribe(toTopic topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                log.error(error.localizedDescription)
            } else {
                log.verbose("Subscribed to \(topic) topic")
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
