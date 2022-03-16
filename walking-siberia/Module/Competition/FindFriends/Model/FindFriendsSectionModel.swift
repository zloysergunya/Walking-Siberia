import IGListDiffKit

class FindFriendsSectionModel {
    
    let user: User
    let isJoined: Bool
    
    init(user: User, isJoined: Bool) {
        self.user = user
        self.isJoined = isJoined
    }
    
}

// MARK: - ListDiffable
extension FindFriendsSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(user.userId) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.user == user && object.isJoined == isJoined
    }
    
}
