import IGListDiffKit

class ExpertSectionModel {
    
    let expert: Expert
    
    init(expert: Expert) {
        self.expert = expert
    }
    
}

// MARK: - ListDiffable
extension ExpertSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(expert.id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.expert == expert
    }
    
}
