import IGListDiffKit

class NotificationSectionModel {
    
    var notifications: [Notification]
    
    init(notifications: [Notification]) {
        self.notifications = notifications
    }
    
}

// MARK: - ListDiffable
extension NotificationSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return 0 as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.notifications == notifications
    }
    
}
