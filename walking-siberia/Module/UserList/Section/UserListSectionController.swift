import IGListKit
import UIKit

protocol UserListSectionControllerDelegate: AnyObject {
    func userListSectionController(didSelect user: User)
    func userListSectionController(willDisplay cell: UICollectionViewCell, at section: Int)
}

class UserListSectionController: ListSectionController {
    
    weak var delegate: UserListSectionControllerDelegate?
    
    private var sectionModel: UserListSectionModel!
    
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
        let cell = collectionContext!.dequeue(of: UserCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is UserListSectionModel)
        sectionModel = object as? UserListSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.userListSectionController(didSelect: sectionModel.user)
    }
    
    private func configure(cell: UserCell) -> UICollectionViewCell {
        let fullName = "\(sectionModel.user.profile.firstName) \(sectionModel.user.profile.lastName)"
        cell.nameLabel.text = fullName
        
        cell.stepsCountLabel.text = R.string.localizable.stepsCount(number: sectionModel.user.dailyStats.number)
        cell.distanceLabel.text = "\(sectionModel.user.dailyStats.km) км"
        
        cell.imageView.image = nil
        if let url = sectionModel.user.profile.avatar {
            ImageLoader.setImage(url: url, imgView: cell.imageView)
        } else {
            let side = 48.0
            cell.imageView.image = UIImage.createWithBgColorFromText(text: fullName.getInitials(), color: .clear, circular: true, side: side)
            let gradientLayer = GradientHelper.shared.layer(color: .linearRed)
            gradientLayer?.frame = CGRect(side: side)
            cell.gradientLayer = gradientLayer
        }
                
        return cell
    }

}

// MARK: - ListDisplayDelegate
extension UserListSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        delegate?.userListSectionController(willDisplay: cell, at: section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
