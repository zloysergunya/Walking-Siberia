import IGListKit
import Atributika
import UIKit

protocol TeamSectionControllerDelegate: AnyObject {
    func teamSectionController(didSelect team: Team)
    func teamSectionController(willDisplay cell: UICollectionViewCell, at section: Int)
}

class TeamSectionController: ListSectionController {
    
    weak var delegate: TeamSectionControllerDelegate?
    
    private var sectionModel: TeamSectionModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 8.0, right: 0.0)
        minimumLineSpacing = 8.0
        
        displayDelegate = self
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let inset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        
        return CGSize(width: collectionContext!.containerSize.width, height: 72.0).inset(by: inset)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: TeamCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is TeamSectionModel)
        sectionModel = object as? TeamSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.teamSectionController(didSelect: sectionModel.team)
    }
    
    private func configure(cell: TeamCell) -> UICollectionViewCell {
        cell.nameLabel.text = sectionModel.team.name
        
        let userCategory: UserCategory? = .init(rawValue: sectionModel.team.type)
        cell.categoryLabel.text = userCategory?.categoryName
        
        let bold = Style("bold")
            .font(R.font.geometriaBold(size: 20.0) ?? .systemFont(ofSize: 20.0))
            .foregroundColor(R.color.graphicBlue() ?? .blue)
        
        cell.stepsCountLabel.attributedText = "<bold>\("7777,7K")</bold>\nшаги".style(tags: bold).attributedString
        
        if userCategory == .manWithHIA {
            if let url = sectionModel.team.users.first?.user.profile.avatar {
                ImageLoader.setImage(url: url, imgView: cell.imageView)
            } else {
                cell.imageView.image = UIImage.createWithBgColorFromText(text: sectionModel.team.name.getInitials(), color: .clear, circular: true, side: 48.0)
                cell.gradientLayer = GradientHelper.shared.layer(color: .linearRed)
            }
        } else {
            cell.imageView.image = UIImage.createWithBgColorFromText(text: "\(sectionModel.team.users.count)/\(5)", color: .clear, circular: true, side: 48.0)
            cell.gradientLayer = GradientHelper.shared.layer(color: .linearBlue)
        }
        
        cell.contentView.layer.borderWidth = sectionModel.team.isJoined ? 1.0 : 0.0
        
        return cell
    }
    
}

// MARK: - ListDisplayDelegate
extension TeamSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        delegate?.teamSectionController(willDisplay: cell, at: section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
