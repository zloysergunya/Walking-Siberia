import IGListKit
import UIKit

protocol TrainersSectionControllerDelegate: AnyObject {
    func trainersSectionController(didSelectCallActionFor trainer: Trainer)
}

class TrainersSectionController: ListSectionController {
    
    weak var delegate: TrainersSectionControllerDelegate?
    
    private var sectionModel: TrainerSectionModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 12.0, right: 0.0)
        minimumLineSpacing = 12.0
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let inset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        
        return CGSize(width: collectionContext!.containerSize.width, height: 288.0).inset(by: inset)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: TrainerCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is TrainerSectionModel)
        sectionModel = object as? TrainerSectionModel
    }
    
    private func configure(cell: TrainerCell) -> UICollectionViewCell {
        ImageLoader.setImage(url: sectionModel.trainer.photo, imgView: cell.imageView)
        
        cell.nameLabel.text = "\(sectionModel.trainer.firstName) \(sectionModel.trainer.lastName)"
        cell.positionLabel.text = sectionModel.trainer.description
        cell.placeOfTrainingLabel.text = sectionModel.trainer.placeOfTraining
        cell.timeOfTrainingLabel.text = sectionModel.trainer.trainingTime
        cell.phoneLabel.text = sectionModel.trainer.phone
        
        cell.callButton.removeTarget(nil, action: #selector(callAction), for: .touchUpInside)
        cell.callButton.addTarget(self, action: #selector(callAction), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func callAction() {
        delegate?.trainersSectionController(didSelectCallActionFor: sectionModel.trainer)
    }
    
}
