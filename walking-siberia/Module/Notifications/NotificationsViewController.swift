import UIKit
import IGListKit

class NotificationsViewController: ViewController<NotificationsView> {
    
    private let provider = NotificationsProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var loadingState: LoadingState = .none
    private var objects: [NotificationSectionModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navBar.leftButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadNotifications(flush: true)
    }
    
    private func loadNotifications(flush: Bool) {
        guard loadingState != .loading else {
            return
        }
        
        loadingState = .loading
        
        provider.loadNotifications(filter: "") { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let videos):
                if flush {
                    self.objects.removeAll()
                }
                
                self.objects = videos.map({ NotificationSectionModel(notification: $0) })
                self.loadingState = .loaded
                self.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed
                self.adapter.performUpdates(animated: true)
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
                if let index = self.objects.firstIndex(where: { $0.notification.id == id }) {
                    self.objects.remove(at: index)
                }
                
                self.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func pullToRefresh() {
        loadNotifications(flush: true)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension NotificationsViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = NotificationsSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView()
    }

}

// MARK: - NotificationsSectionControllerDelegate
extension NotificationsViewController: NotificationsSectionControllerDelegate {
    
    func notificationsSectionController(didSelect notification: Notification) {
        
    }
    
    func notificationsSectionController(didSelectRemoveActionFor notification: Notification) {
        hideNotification(id: notification.id)
    }
    
    func notificationsSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= objects.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadNotifications(flush: false)
        }
    }
    
}
