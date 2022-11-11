import IGListDiffKit

class TeamEditSectionModel {
    
    let users: [Participant]
    let team: Team?
    
    init(users: [Participant], team: Team?) {
        self.users = users
        self.team = team
    }
    
}

// MARK: - ListDiffable
extension TeamEditSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return 0 as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.users == users && object.team == team
    }
    
}
