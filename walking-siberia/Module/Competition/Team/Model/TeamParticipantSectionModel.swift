import IGListDiffKit

class TeamParticipantSectionModel {
    
    let user: Participant
    let team: Team
    
    init(user: Participant, team: Team) {
        self.user = user
        self.team = team
    }
    
}

// MARK: - ListDiffable
extension TeamParticipantSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(user.userId) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.user == user && object.team == team
    }
    
}
