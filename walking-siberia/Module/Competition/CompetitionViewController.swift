import UIKit
import IGListKit

enum CompetitionType {
    case current, ended
}

class CompetitionViewController: ViewController<CompetitionView> {
    
    private let type: CompetitionType
    private let provider = CompetitionProvider()
    
    private var loadingState: LoadingState = .none
    private var objects: [CompetitionSectionModel] = []
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)

    init(type: CompetitionType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        
        switch type {
        case .current: title = "Текущие"
        case .ended: title = "Завершившиеся"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        load()
    }
    
    private func load() {
        guard loadingState != .loading else {
            return
        }
        
        loadingState = .loading
        
        provider.loadCompetitions { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(var competitions):
                switch self.type {
                case .current: competitions = competitions.filter({ !$0.isClosed })
                case .ended: competitions = competitions.filter({ $0.isClosed })
                }
                
                self.objects = competitions.map({ CompetitionSectionModel(competition: $0) })
                self.loadingState = .loaded
                self.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self.loadingState = .failed
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    @objc private func pullToRefresh() {
        load()
    }
    
}

// MARK: - ListAdapterDataSource
extension CompetitionViewController: ListAdapterDataSource {
   
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = CompetitionSectionController()
//        sectionController.delegate = self
        
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView()
    }
    
}
