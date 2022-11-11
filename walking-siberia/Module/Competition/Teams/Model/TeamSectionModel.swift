import Foundation
import IGListDiffKit

class TeamSectionModel {
    
    var team: Team?
    let isDisabled: Bool
    
    init(team: Team?, isDisabled: Bool) {
        self.team = team
        self.isDisabled = isDisabled
    }
    
}

// MARK: - ListDiffable
extension TeamSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(team?.id ?? 0) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.team == team && object.isDisabled == isDisabled
    }
    
}
