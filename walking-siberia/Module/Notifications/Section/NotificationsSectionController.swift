import IGListKit
import UIKit

protocol NotificationsSectionControllerDelegate: AnyObject {
    func notificationsSectionController(didSelect notification: Notification)
    func notificationsSectionController(didSelectRemoveActionFor notification: Notification)
    func notificationsSectionController(willDisplay cell: UICollectionViewCell, at section: Int)
}

class NotificationsSectionController: ListSectionController {
    
    weak var delegate: NotificationsSectionControllerDelegate?
    
    private var sectionModel: NotificationSectionModel!
    
    private let cellTemplate = NotificationCell()
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 12.0, right: 0.0)
        minimumLineSpacing = 12.0
        
        displayDelegate = self
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let inset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        
        return configure(cell: cellTemplate).sizeThatFits(collectionContext!.containerSize).inset(by: inset)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: NotificationCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is NotificationSectionModel)
        sectionModel = object as? NotificationSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.notificationsSectionController(didSelect: sectionModel.notification)
    }
    
    private func configure(cell: NotificationCell) -> UICollectionViewCell {
        cell.unreadView.isHidden = sectionModel.notification.isViewed
        cell.titleLabel.text = sectionModel.notification.title
        cell.messageLabel.text = sectionModel.notification.message
        
        let notificationType: NotificationType? = .init(rawValue: sectionModel.notification.type)
        cell.typeLabel.text = notificationType?.title
        cell.typeImageView.image = notificationType?.image
        
        cell.removeButton.removeTarget(nil, action: #selector(removeAction), for: .touchUpInside)
        cell.removeButton.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func removeAction(_ button: UIButton) {
        delegate?.notificationsSectionController(didSelectRemoveActionFor: sectionModel.notification)
    }
    
}

// MARK: - ListDisplayDelegate
extension NotificationsSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        delegate?.notificationsSectionController(willDisplay: cell, at: section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
