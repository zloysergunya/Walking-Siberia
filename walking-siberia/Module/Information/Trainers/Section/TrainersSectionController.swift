import IGListKit
import UIKit

protocol TrainersSectionControllerDelegate: AnyObject {
    func trainersSectionController(didSelectCallActionFor trainer: Trainer)
}

class TrainersSectionController: ListSectionController {
    
    weak var delegate: TrainersSectionControllerDelegate?
    
    private let cellTemplate = TrainerCell()
    
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
        
        return configure(cell: cellTemplate).sizeThatFits(collectionContext!.containerSize).inset(by: inset)
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
        let fullName = "\(sectionModel.trainer.firstName) \(sectionModel.trainer.lastName)"
        cell.nameLabel.text = fullName
        
        if let url = sectionModel.trainer.photo {
            ImageLoader.setImage(url: url, imgView: cell.imageView)
        } else {
            let side = TrainerCell.Layout.avatarSide
            let textAttributes: [NSAttributedString.Key: Any] = [.font: R.font.geometriaBold(size: 24.0)!, .foregroundColor: UIColor.white]
            cell.imageView.image = UIImage.createWithBgColorFromText(text: fullName.getInitials(),
                                                                     color: .clear,
                                                                     circular: true,
                                                                     textAttributes: textAttributes,
                                                                     side: side)
            let gradientLayer = GradientHelper.shared.layer(color: .linearRed)
            gradientLayer?.frame = CGRect(side: side)
            cell.gradientLayer = gradientLayer
        }
        
        cell.positionLabel.text = sectionModel.trainer.description
        
        cell.placeOfTrainingLabel.text = sectionModel.trainer.placeOfTraining
        cell.placeOfTrainingLabel.isHidden = sectionModel.trainer.placeOfTraining.isEmpty
        cell.placeOfTrainingTitleLabel.isHidden = sectionModel.trainer.placeOfTraining.isEmpty
        
        cell.timeOfTrainingLabel.text = sectionModel.trainer.trainingTime
        cell.timeOfTrainingLabel.isHidden = sectionModel.trainer.trainingTime.isEmpty
        cell.timeOfTrainingTitleLabel.isHidden = sectionModel.trainer.trainingTime.isEmpty
        
        cell.phoneLabel.text = sectionModel.trainer.phone
        
        cell.callButton.removeTarget(nil, action: #selector(callAction), for: .touchUpInside)
        cell.callButton.addTarget(self, action: #selector(callAction), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func callAction() {
        delegate?.trainersSectionController(didSelectCallActionFor: sectionModel.trainer)
    }
    
}
