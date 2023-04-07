import UIKit
import IGListKit

class ExpertQAViewController: ViewController<ExpertQAView> {

    private let expert: Expert
    private let provider = ExpertQAProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private lazy var objects: [ExpertQuestionSectionModel] = UserSettings.expertsQuestions?
        .filter({ $0.expertId == expert.id })
        .map({ ExpertQuestionSectionModel(expertQuestion: $0) }) ?? []
    
    private var loadingState: LoadingState = .none {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }
    
    init(expert: Expert) {
        self.expert = expert
        super.init(nibName: nil, bundle: nil)
        
        title = expert.firstName + " " + expert.lastName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.sendButton.addTarget(self, action: #selector(writeQuestions), for: .touchUpInside)
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        loadQuestions()
    }
    
    private func loadQuestions() {
        guard loadingState != .loading else { return }
        
        loadingState = .loading
        
        provider.loadQuestions(id: expert.id) { [weak self] result in
            guard let self = self else { return }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let questions):
                questions.forEach({ UserSettings.expertsQuestions?.insert($0) })
                self.objects = questions.map({ ExpertQuestionSectionModel(expertQuestion: $0) })
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
            }
        }
    }
    
    @objc private func writeQuestions() {
        Utils.impact()
        let viewController = SendToExpertViewController(expert: expert)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func pullToRefresh() {
        loadQuestions()
    }
    
}

// MARK: - ListAdapterDataSource
extension ExpertQAViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = ExpertQuestionSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: loadingState)
    }
}

// MARK: - ExpertQuestionSectionControllerDelegate
extension ExpertQAViewController: ExpertQuestionSectionControllerDelegate {
    func expertQuestionSectionController(_ sectionController: ExpertQuestionSectionController, didSelect item: ExpertQuestion, at index: Int) {
        Utils.impact()
        objects[index].isAnswerShown.toggle()        
        adapter.reloadData()
    }
}
