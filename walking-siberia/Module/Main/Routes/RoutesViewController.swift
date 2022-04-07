import UIKit
import IGListKit
import Atributika

class RoutesViewController: ViewController<RoutesView> {
    
    private let provider = RoutesProvider()
    private let healthService: HealthService? = ServiceLocator.getService()
    private let notificationsAccessService = NotificationsAccessService()
    
    private var objects: [RouteSectionModel] = UserSettings.routes?.map({ RouteSectionModel(route: $0) }) ?? []
    private var loadingState: LoadingState = .none
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.statsButton.addTarget(self, action: #selector(openStatistics), for: .touchUpInside)
        mainView.stepsCountView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openStatistics)))
        mainView.notifyButton.addTarget(self, action: #selector(openNotifications), for: .touchUpInside)
        
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        notificationsAccessService.output = self
        notificationsAccessService.requestAccess()
        
        healthService?.output = self
        healthService?.requestAccess()
        
        mainView.stepsCountView.setup(with: 0, distance: 0.0)
        
        syncContacts()
        syncUserActivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        loadRoutes()
        updateCountNewNotifications()
    }
    
    private func loadRoutes() {
        guard loadingState != .loading else {
            return
        }
        
        loadingState = .loading
        
        provider.routes { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
                        
            switch result {
            case .success(let routes):
                UserSettings.routes = routes
                self.objects = routes.map({ RouteSectionModel(route: $0) })
                
                self.adapter.reloadData(completion: nil)
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    private func syncContacts() {
        ContactsService.getContacts { [weak self] contacts in
            self?.provider.syncContacts(contacts: contacts) { [weak self] result in
                switch result {
                case .success: break
                case .failure(let error):
                    self?.showError(text: error.localizedDescription)
                }
            }
        }
    }
    
    private func syncUserActivity() {
        let lastDate = UserSettings.lastSendActivityDate?.add(.day, value: -7) ?? Date()
        let toDate = Date()
        
        Date.dates(from: lastDate, to: toDate).forEach { date in
            healthService?.getUserActivity(date: date) { [weak self] (stepsCount, distance) in
                DispatchQueue.main.async {
                    if Calendar.current.isDate(date, inSameDayAs: Date()) {
                        self?.mainView.stepsCountView.setup(with: stepsCount, distance: distance)
                    }
                }
            }
        }
    }
    
    private func sendPushToken(_ token: String) {
        provider.sendPushToken(token: token) { [weak self] result in
            switch result {
            case .success: break
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func updateCountNewNotifications() {
        provider.updateCountNewNotifications { [weak self] result in
            switch result {
            case .success(let count):
                self?.mainView.notifyButton.badge = count > 0 ? "\(count)" : nil
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func pullToRefresh() {
        loadRoutes()
    }
    
    @objc private func openStatistics() {
        guard let user = UserSettings.user else {
            return
        }
        
        let pagerViewController = PagerViewController(type: .statistics(user: user))
        navigationController?.pushViewController(pagerViewController, animated: true)
    }
    
    @objc private func openNotifications() {
        let viewController = NotificationsViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension RoutesViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = RouteSectionController()
        sectionController.delegate = self
        
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView()
    }
    
}

// MARK: - RouteSectionControllerDelegate
extension RoutesViewController: RouteSectionControllerDelegate {
    
    func routeSectionController(_ sectionController: RouteSectionController, didSelect sectionModel: RouteSectionModel) {
        let viewController = RouteInfoViewController(route: sectionModel.route)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - NotificationsAccessServiceOutput
extension RoutesViewController: NotificationsAccessServiceOutput {
    
    func successRequest(granted: Bool) {}
    
    func didReceiveRegistrationToken(token: String) {
        sendPushToken(token)
    }
    
    func failureRequest(error: Error) {
        showError(text: error.localizedDescription)
    }
    
}

// MARK: - HealthServiceOutput
extension RoutesViewController: HealthServiceOutput {
    
    func successHealthAccessRequest(granted: Bool) {
        if granted {
            syncUserActivity()
        }
    }
    
    func failureHealthAccessRequest(error: Error) {
        log.error(error.localizedDescription)
        showError(text: error.localizedDescription)
    }
    
}

extension Date {
    
    func add(_ unit: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: unit, value: value, to: self)
    }
    
}
