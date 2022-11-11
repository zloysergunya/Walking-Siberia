import IGListDiffKit

class FindFriendsSectionModel {
    
    let user: User
    var inTeam: Bool
    
    init(user: User, inTeam: Bool) {
        self.user = user
        self.inTeam = inTeam
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
        
        return object.user == user && object.inTeam == inTeam
    }
    
}
