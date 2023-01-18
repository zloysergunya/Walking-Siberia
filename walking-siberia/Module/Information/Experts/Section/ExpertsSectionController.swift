import IGListKit
import UIKit

protocol ExpertsSectionControllerDelegate: AnyObject {
    func expertsSectionController(didSelect item: Expert, at index: Int)
}

class ExpertsSectionController: ListSectionController {
    
    weak var delegate: ExpertsSectionControllerDelegate?
    
    private let cellTemplate = ExpertCell()
    
    private var sectionModel: ExpertSectionModel!
    
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
        let cell = collectionContext!.dequeue(of: ExpertCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is ExpertSectionModel)
        sectionModel = object as? ExpertSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.expertsSectionController(didSelect: sectionModel.expert, at: section)
    }
    
    private func configure(cell: ExpertCell) -> UICollectionViewCell {
        let fullName = "\(sectionModel.expert.firstName) \(sectionModel.expert.lastName)"
        cell.nameLabel.text = fullName
        
        if let url = sectionModel.expert.photo {
            ImageLoader.setImage(url: url, imgView: cell.imageView)
        } else {
            let side = ExpertCell.Layout.avatarSide
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
        
        cell.specializationLabel.text = sectionModel.expert.specialization
        cell.descriptionLabel.text = sectionModel.expert.description
        cell.phoneLabel.text = sectionModel.expert.phone ?? "Нет данных"
        
        return cell
    }
    
}
