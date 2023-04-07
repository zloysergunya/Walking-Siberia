import IGListKit
import UIKit

protocol ExpertQuestionSectionControllerDelegate: AnyObject {
    func expertQuestionSectionController(_ sectionController: ExpertQuestionSectionController, didSelect item: ExpertQuestion, at index: Int)
}

class ExpertQuestionSectionController: ListSectionController {
    
    weak var delegate: ExpertQuestionSectionControllerDelegate?
    
    private let cellTemplate = ExpertQuestionCell()
    
    private var sectionModel: ExpertQuestionSectionModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 12.0, right: 0.0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let inset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        return configure(cell: cellTemplate).sizeThatFits(collectionContext!.containerSize).inset(by: inset)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: ExpertQuestionCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is ExpertQuestionSectionModel)
        sectionModel = object as? ExpertQuestionSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.expertQuestionSectionController(self ,didSelect: sectionModel.expertQuestion, at: section)
    }
    
    private func configure(cell: ExpertQuestionCell) -> UICollectionViewCell {
        cell.questionLabel.text = sectionModel.expertQuestion.question
        cell.answerLabel.text = sectionModel.expertQuestion.answer
        cell.answerLabel.isHidden = !sectionModel.isAnswerShown
        
        return cell
    }
    
}
