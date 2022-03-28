import UIKit
import IGListKit

class TeamsViewController: ViewController<TeamsView> {
    
    private var competition: Competition
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
        mainView.createTeamButton.addTarget(self, action: #selector(openCreateTeam), for: .touchUpInside)
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
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        loadTeams(flush: true)
        updateCompetition()
    }
    
    private func configure() {        
        if let type = UserSettings.user?.type {
            let userCategory: UserCategory? = .init(rawValue: type)
            
            mainView.createTeamButton.isHidden = userCategory == .manWithHIA
            mainView.takePartButton.isHidden = userCategory != .manWithHIA
            
            if userCategory == .manWithHIA {
                mainView.takePartButton.setTitle(competition.isJoined ? "Покинуть соревнование" : "Принять участие", for: .normal)
            }
        }
    }
    
    private func updateCompetition() {
        provider.updateCompetition(competitionId: competition.id) { [weak self] result in
            guard let self = self else {
                return
            }
            
            
            switch result {
            case .success(let competition):
                self.competition = competition
                self.configure()
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
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
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    private func createTeam() {
        guard let user = UserSettings.user else {
            return
        }

        let teamCreateRequest = TeamCreateRequest(competitionId: competition.id,
                                                  name: "\(user.profile.firstName) \(user.profile.lastName)",
                                                  status: 1,
                                                  userIds: [])
        provider.createTeam(teamCreateRequest: teamCreateRequest) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let team):
                self.objects.insert(TeamSectionModel(team: team), at: 0)
                self.updateCompetition()
                self.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func deleteTeam(teamId: Int) {
        provider.deleteTeam(teamId: teamId) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success:
                if let index = self.objects.firstIndex(where: { $0.team.id == teamId }) {
                    self.objects.remove(at: index)
                }
                self.updateCompetition()
                self.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
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

        self.filter = filter
        loadTeams(flush: true)
    }
    
    @objc private func openCreateTeam() {
        navigationController?.pushViewController(TeamEditViewController(competition: competition, type: .create), animated: true)
    }
    
    @objc private func takePart() {
        if competition.isJoined {
            deleteTeam(teamId: 34) // TODO: сменить на новый запрос
        } else {
            createTeam()
        }
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
        if UserCategory(rawValue: team.type) == .manWithHIA, let user = team.users.first?.user {
            navigationController?.pushViewController(UserProfileViewController(user: user), animated: true)
        } else {
            navigationController?.pushViewController(TeamViewController(team: team, competition: competition), animated: true)
        }
    }
    
    func teamSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= objects.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadTeams(flush: false)
        }
    }
    
}
