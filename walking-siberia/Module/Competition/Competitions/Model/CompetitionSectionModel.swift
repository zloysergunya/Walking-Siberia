import Foundation
import IGListDiffKit

class CompetitionSectionModel {
    
    let competition: Competition
    
    init(competition: Competition) {
        self.competition = competition
    }
    
}

// MARK: - ListDiffable
extension CompetitionSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(competition.id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.competition == competition
    }
    
}
