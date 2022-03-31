import IGListDiffKit

class NotificationSectionModel {
    
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
}

// MARK: - ListDiffable
extension NotificationSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(notification.id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.notification == notification
    }
    
}
