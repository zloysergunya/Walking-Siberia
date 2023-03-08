import IGListDiffKit

class ExpertQuestionSectionModel {
    
    let expertQuestion: ExpertQuestion
    var isAnswerShown: Bool = false
    
    init(expertQuestion: ExpertQuestion) {
        self.expertQuestion = expertQuestion
    }
    
}

// MARK: - ListDiffable
extension ExpertQuestionSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(expertQuestion.id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.expertQuestion == expertQuestion && object.isAnswerShown == isAnswerShown
    }
    
}
