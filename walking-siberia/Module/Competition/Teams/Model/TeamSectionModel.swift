import Foundation
import IGListDiffKit

class TeamSectionModel {
    
    let team: Team
    
    init(team: Team) {
        self.team = team
    }
    
}

// MARK: - ListDiffable
extension TeamSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(team.id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.team == team
    }
    
}
