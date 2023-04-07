import UIKit
import IGListKit

class NotificationsViewController: ViewController<NotificationsView> {
    
    private let provider = NotificationsProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var notifications: [Notification] = []
    private var loadingState: LoadingState = .none {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navBar.leftButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.clearAllButton.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        loadNotifications(flush: true)
    }
    
    private func loadNotifications(flush: Bool) {
        guard loadingState != .loading else {
            return
        }
        
        loadingState = .loading
        
        if flush {
            provider.page = 1
        }
        
        provider.loadNotifications(filter: "") { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let notifications):
                if flush {
                    self.notifications.removeAll()
                }
                
                self.notifications.append(contentsOf: notifications)
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
            }
        }
    }
    
    private func readNotification(id: Int) {
        provider.readNotification(id: id) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success:
                if let index = self.notifications.firstIndex(where: { $0.id == id }) {
                    self.notifications[index].isViewed = true
                }
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func hideNotification(id: Int) {
        provider.hideNotification(id: id) { [weak self] result in
            guard let self = self else {
                return
            }
                        
            switch result {
            case .success:
                if let index = self.notifications.firstIndex(where: { $0.id == id }) {
                    self.notifications.remove(at: index)
                }
                
                self.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func handleNotification(_ notification: Notification) {
        guard let notificationType = NotificationType(rawValue: notification.type) else { return }
        
        let url = Constants.deepLinkPath + notificationType.rawValue + "/\(notification.extra.id)"
        UIApplication.shared.open(URL(string: url)!)
    }
    
    @objc private func pullToRefresh() {
        loadNotifications(flush: true)
    }
    
    @objc private func clearAll() {
        provider.clearAll { [weak self] result in
            switch result {
            case .success:
                self?.notifications.removeAll()
                self?.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension NotificationsViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [NotificationSectionModel(notifications: notifications)]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = NotificationsSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: loadingState)
    }

}

// MARK: - NotificationsSectionControllerDelegate
extension NotificationsViewController: NotificationsSectionControllerDelegate {
    
    func notificationsSectionController(didSelect notification: Notification) {
        handleNotification(notification)
    }
    
    func notificationsSectionController(didSelectRemoveActionFor notification: Notification) {
        hideNotification(id: notification.id)
    }
    
    func notificationsSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if !notifications[section].isViewed {
            readNotification(id: notifications[section].id)
        }
        
        if section + 1 >= notifications.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadNotifications(flush: false)
        }
    }
    
}
