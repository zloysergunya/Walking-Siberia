import UIKit
import IGListKit

class TeamsViewController: ViewController<TeamsView> {
    
    private let competition: Competition
    private let provider = TeamsProvider()
    
    private var loadingState: LoadingState = .none
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var objects: [TeamSectionModel] = []
    private var filter = ""
    private var filterButtons: [UIButton] {
        return [mainView.childrenButton, mainView.studentButton, mainView.adultButton,
                mainView.pensionerButton, mainView.manWithHIAButton]
    }
        
    init(competition: Competition) {
        self.competition = competition
        super.init(nibName: nil, bundle: nil)
        
        title = "Команды-участники"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        mainView.createTeamButton.addTarget(self, action: #selector(createTeam), for: .touchUpInside)
        mainView.takePartButton.addTarget(self, action: #selector(takePart), for: .touchUpInside)
        mainView.childrenButton.addTarget(self, action: #selector(updateFilter), for: .touchUpInside)
        mainView.studentButton.addTarget(self, action: #selector(updateFilter), for: .touchUpInside)
        mainView.adultButton.addTarget(self, action: #selector(updateFilter), for: .touchUpInside)
        mainView.pensionerButton.addTarget(self, action: #selector(updateFilter), for: .touchUpInside)
        mainView.manWithHIAButton.addTarget(self, action: #selector(updateFilter), for: .touchUpInside)
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadTeams(flush: true)
    }
    
    private func configure() {
        mainView.teamsCountLabel.text = "Найдено команд: \(competition.countTeams)"
        
        if let type = UserSettings.user?.type {
            let userCategory: UserCategory? = .init(rawValue: type)
            
            mainView.createTeamButton.isHidden = userCategory == .manWithHIA
            mainView.takePartButton.isHidden = userCategory != .manWithHIA
            
            if userCategory == .manWithHIA {
                mainView.takePartButton.setTitle(competition.isJoined ? "Покинуть соревнование" : "Принять участие", for: .normal)
            }
        }
    }
    
    private func loadTeams(flush: Bool) {
        guard loadingState != .loading else { return }
        
        loadingState = .loading
        
        if flush {
            provider.page = 1
        }

        provider.loadTeams(uid: competition.id, filter: filter) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let teams):
                if flush {
                    self.objects.removeAll()
                }
                
                self.objects.append(contentsOf: teams.map({ TeamSectionModel(team: $0) }))
                self.loadingState = .loaded
                self.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self.loadingState = .failed
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    @objc private func pullToRefresh() {
        loadTeams(flush: true)
    }
    
    @objc private func updateFilter(_ sender: UIButton) {
        var filter = ""
        filterButtons.forEach({ button in
            if button.tag == sender.tag && button.isSelected {
                button.isSelected = false
            } else {
                button.isSelected = button.tag == sender.tag
                if button.isSelected {
                    filter = "\(sender.tag)"
                }
            }
        })
        print("filter", filter)
        self.filter = filter
        loadTeams(flush: true)
    }
    
    @objc private func createTeam() {
        
    }
    
    @objc private func takePart() {
        
    }
    
}

// MARK: - ListAdapterDataSource
extension TeamsViewController: ListAdapterDataSource {
   
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = TeamSectionController()
        sectionController.delegate = self
        
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView()
    }
    
}

// MARK: - TeamSectionControllerDelegate
extension TeamsViewController: TeamSectionControllerDelegate {
    
    func teamSectionController(didSelect team: Team) {
        
    }
    
    func teamSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= objects.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadTeams(flush: false)
        }
    }
    
}
