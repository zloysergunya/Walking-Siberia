import UIKit
import IGListKit
import SwiftyMenu

class TrainersViewController: ViewController<TrainersView> {
    
    private let provider = TrainersProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var objects: [TrainerSectionModel] = UserSettings.trainers?.map({ TrainerSectionModel(trainer: $0) }) ?? []
    private var loadingState: LoadingState = .none {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }
    private var selectedCity: RouteCity? {
        didSet {
            loadTrainers(flush: true)
        }
    }
    
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
        
        mainView.dropDownMenu.delegate = self
    }
    
    private func loadTrainers(flush: Bool) {
        guard loadingState != .loading else { return }
        
        loadingState = .loading
        
        provider.loadTrainers(cityId: selectedCity?.id) { [weak self] result in
            guard let self = self else { return }
            
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
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
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
        return EmptyView(loadingState: loadingState)
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

// MARK: - DropDownViewDelegate
extension TrainersViewController: DropDownViewDelegate {
    func dropDownView(_ dropDownView: DropDownView, didSelect item: SwiftyMenuDisplayable, at index: Int) {
        Utils.impact()
        
        guard let city = item.retrievableValue as? RouteCity else { return }
        selectedCity = city
    }
}
