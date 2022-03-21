import IGListDiffKit

class TrainerSectionModel {
    
    let trainer: Trainer
    
    init(trainer: Trainer) {
        self.trainer = trainer
    }
    
}

// MARK: - ListDiffable
extension TrainerSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(trainer.id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.trainer == trainer
    }
    
}
