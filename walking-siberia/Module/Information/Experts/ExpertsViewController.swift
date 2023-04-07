import UIKit
import IGListKit

class ExpertsViewController: ViewController<ExpertsView> {
    
    private let provider = ExpertsProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var objects: [ExpertSectionModel] = UserSettings.experts?.map({ ExpertSectionModel(expert: $0) }) ?? []
    private var loadingState: LoadingState = .none {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        
        title = "Эксперты"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadExperts(flush: true)
    }
    
    private func loadExperts(flush: Bool) {
        guard loadingState != .loading else { return }
        
        loadingState = .loading
        
        provider.loadExperts() { [weak self] result in
            guard let self = self else { return }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let experts):
                if flush {
                    self.objects.removeAll()
                    UserSettings.experts = []
                }
                
                UserSettings.experts?.append(contentsOf: experts)
                self.objects.append(contentsOf: experts.map({ ExpertSectionModel(expert: $0) }))
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
            }
        }
    }
    
    @objc private func pullToRefresh() {
        loadExperts(flush: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension ExpertsViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = ExpertsSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: loadingState)
    }

}

// MARK: - ListAdapterDataSource
extension ExpertsViewController: ExpertsSectionControllerDelegate {
    
    func expertsSectionController(didSelect item: Expert, at index: Int) {
        let viewController = ExpertQAViewController(expert: item)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
