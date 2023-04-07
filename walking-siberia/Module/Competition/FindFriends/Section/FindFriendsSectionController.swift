import IGListKit
import UIKit

protocol FindFriendsSectionControllerDelegate: AnyObject {
    func findFriendsSectionController(didSelect user: User)
    func findFriendsSectionController(didSelectAction button: UIButton, inTeam: Bool, user: User)
    func findFriendsSectionController(willDisplay cell: UICollectionViewCell, at section: Int)
}

class FindFriendsSectionController: ListSectionController {
    
    weak var delegate: FindFriendsSectionControllerDelegate?
    
    private var sectionModel: FindFriendsSectionModel!
    
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
        let cell = collectionContext!.dequeue(of: FindFriendsCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is FindFriendsSectionModel)
        sectionModel = object as? FindFriendsSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.findFriendsSectionController(didSelect: sectionModel.user)
    }
    
    private func configure(cell: FindFriendsCell) -> UICollectionViewCell {
        let fullName = "\(sectionModel.user.profile.firstName) \(sectionModel.user.profile.lastName)"
        cell.nameLabel.text = fullName
                
        if let url = sectionModel.user.profile.avatar {
            ImageLoader.setImage(url: url, imgView: cell.imageView)
        } else {
            cell.imageView.image = UIImage.createWithBgColorFromText(text: fullName.getInitials(), color: .clear, circular: true, side: 48.0)
            let gradientLayer = GradientHelper.shared.layer(userId: sectionModel.user.userId)
            gradientLayer?.frame = CGRect(side: 48.0)
            cell.gradientLayer = gradientLayer
        }
        
        cell.actionButton.isSelected = sectionModel.inTeam
        cell.actionButton.removeTarget(nil, action: #selector(action), for: .touchUpInside)
        cell.actionButton.addTarget(self, action: #selector(action), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func action(_ sender: UIButton) {
        delegate?.findFriendsSectionController(didSelectAction: sender, inTeam: sectionModel.inTeam, user: sectionModel.user)
    }
    
}

// MARK: - ListDisplayDelegate
extension FindFriendsSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        delegate?.findFriendsSectionController(willDisplay: cell, at: section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
