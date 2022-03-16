import UIKit
import IGListKit
import Atributika

class RoutesViewController: ViewController<RoutesView> {
    
    private let provider = RoutesProvider()
    
    private var objects: [RouteSectionModel] = []
    private var loadingState: LoadingState = .none
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        mainView.stepsCountView.setup(with: 15500, distance: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        loadRoutes()
        syncContacts()
    }
    
    @objc private func pullToRefresh() {
        loadRoutes()
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
            case .success(let response):
                if let routes = response.data?.map({ RouteSectionModel(route: $0) }) {
                    self.objects = routes
                }
                
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
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
