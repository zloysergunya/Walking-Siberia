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
        
        minimumLineSpacing = 12.0
        minimumInteritemSpacing = 12.0
        
        displayDelegate = self
    }
    
    override func numberOfItems() -> Int {
        return sectionModel.notifications.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return configure(cell: cellTemplate, notification: sectionModel.notifications[index])
            .sizeThatFits(collectionContext!.containerSize)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: NotificationCell.self, for: self, at: index)
        cell.removeButton.tag = index
        cell.removeButton.removeTarget(nil, action: #selector(removeAction), for: .touchUpInside)
        cell.removeButton.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
        
        return configure(cell: cell, notification: sectionModel.notifications[index])
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is NotificationSectionModel)
        sectionModel = object as? NotificationSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.notificationsSectionController(didSelect: sectionModel.notifications[index])
    }
    
    private func configure(cell: NotificationCell, notification: Notification) -> UICollectionViewCell {
        cell.unreadView.isHidden = notification.isViewed
        cell.titleLabel.text = notification.title
        cell.messageLabel.text = notification.message
        
        let notificationType: NotificationType? = .init(rawValue: notification.type)
        cell.typeLabel.text = notificationType?.title
        cell.typeImageView.image = notificationType?.image
        
        return cell
    }
    
    @objc private func removeAction(_ button: UIButton) {
        delegate?.notificationsSectionController(didSelectRemoveActionFor: sectionModel.notifications[button.tag])
    }
    
}

// MARK: - ListDisplayDelegate
extension NotificationsSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        delegate?.notificationsSectionController(willDisplay: cell, at: index)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
