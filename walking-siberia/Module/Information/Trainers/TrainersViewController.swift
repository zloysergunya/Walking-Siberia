import UIKit
import IGListKit

class TrainersViewController: ViewController<TrainersView> {
    
    private let provider = TrainersProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var loadingState: LoadingState = .none
    private var objects: [TrainerSectionModel] = UserSettings.trainers?.map({ TrainerSectionModel(trainer: $0) }) ?? []
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        
        title = "Тренировки"
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
        
        loadTrainers(flush: true)
    }
    
    private func loadTrainers(flush: Bool) {
        guard loadingState != .loading else {
            return
        }
        
        loadingState = .loading
        
        provider.loadTrainers { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let trainers):
                if flush {
                    self.objects.removeAll()
                    UserSettings.trainers = []
                }
                
                UserSettings.trainers?.append(contentsOf: trainers)
                self.objects.append(contentsOf: trainers.map({ TrainerSectionModel(trainer: $0) }))
                self.loadingState = .loaded
                self.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    @objc private func pullToRefresh() {
        loadTrainers(flush: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension TrainersViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = TrainersSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView()
    }

}

// MARK: - TrainersSectionControllerDelegate
extension TrainersViewController: TrainersSectionControllerDelegate {
    
    func trainersSectionController(didSelectCallActionFor trainer: Trainer) {
        if let url = URL(string: "telprompt://\(trainer.phone)") {
            UIApplication.shared.open(url)
        }
    }
    
}
