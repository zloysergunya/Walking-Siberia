import Foundation
import IGListDiffKit

class UserListSectionModel {
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
}

// MARK: - ListDiffable
extension UserListSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(user.userId) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.user == user
    }
    
}
