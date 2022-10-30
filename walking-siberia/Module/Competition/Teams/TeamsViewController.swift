import UIKit
import IGListKit

class TeamsViewController: ViewController<TeamsView> {
    
    enum CompetitionType {
        case team, single
    }
    
    private var competition: Competition
    private let competitionType: CompetitionType
    private let provider = TeamsProvider()
    
    private var loadingState: LoadingState = .none {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var objects: [TeamSectionModel] = []
    private var filter = ""
        
    init(competition: Competition, competitionType: CompetitionType) {
        self.competition = competition
        self.competitionType = competitionType
        super.init(nibName: nil, bundle: nil)
        
        switch competitionType {
        case .team: title = "Команды"
        case .single: title = "Индивидуально"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        mainView.createTeamButton.addTarget(self, action: #selector(openCreateTeam), for: .touchUpInside)
        mainView.takePartButton.addTarget(self, action: #selector(takePart), for: .touchUpInside)
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        configure()
        loadTeams(flush: true)
        updateCompetition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func configure() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        var isCompetitionStarted = false
        if let fromDate = dateFormatter.date(from: competition.fromDate) {
            isCompetitionStarted = Calendar.current.startOfDay(for: fromDate) < Date()
        }

        let isDisabled = UserSettings.user?.isDisabled ?? false
        mainView.createTeamButton.isHidden = isDisabled || competition.isClosed || isCompetitionStarted
        mainView.takePartButton.isHidden = isDisabled || competition.isClosed || isCompetitionStarted
        
        if isDisabled {
            mainView.takePartButton.setTitle(competition.isJoined ? "Покинуть соревнование" : "Принять участие", for: .normal)
        }
    }
    
    private func updateCompetition() {
        provider.updateCompetition(competitionId: competition.id) { [weak self] result in
            guard let self = self else { return }
            
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
            guard let self = self else { return }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(var teams):
                if flush {
                    self.objects.removeAll()
                }
                
                switch self.competitionType {
                case .team: teams = teams.filter({ $0.isDisabled != true })
                case .single: teams = teams.filter({ $0.isDisabled == true })
                }
                
                self.objects.append(contentsOf: teams.map({ TeamSectionModel(team: $0, isDisabled: self.competitionType == .single) }))
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
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
                self.objects.insert(TeamSectionModel(team: team, isDisabled: self.competitionType == .single), at: 0)
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
                if let index = self.objects.firstIndex(where: { $0.team?.id == teamId }) {
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
    
    @objc private func openCreateTeam() {
        navigationController?.pushViewController(TeamEditViewController(competition: competition, type: .create), animated: true)
    }
    
    @objc private func takePart() {
        if competition.isJoined {
            if let teamId = objects.first(where: { $0.team?.ownerId == UserSettings.user?.userId })?.team?.id {
                dialog(title: "Вы хотите покинуть соревнование?", message: "", accessText: "Да", cancelText: "Нет", onAgree:  { [weak self] _ in
                    self?.deleteTeam(teamId: teamId)
                })
            }
        } else {
            createTeam()
        }
    }
    
}

// MARK: - ListAdapterDataSource
extension TeamsViewController: ListAdapterDataSource {
   
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if objects.contains(where: { $0.team == nil }) {
            return objects
        }
        if loadingState == .loaded {
            objects.insert(.init(team: nil, isDisabled: competitionType == .single), at: 0)
        }
        
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = TeamsSectionController()
        sectionController.delegate = self
        
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: loadingState)
    }
    
}

// MARK: - TeamsSectionControllerDelegate
extension TeamsViewController: TeamsSectionControllerDelegate {
    
    func teamsSectionController(didSelect team: Team) {
        if let isDisabled = team.isDisabled, isDisabled {
            navigationController?.pushViewController(UserProfileViewController(userId: team.ownerId), animated: true)
        } else {
            navigationController?.pushViewController(TeamViewController(team: team, competition: competition), animated: true)
        }
    }
    
    func teamsSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= objects.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadTeams(flush: false)
        }
    }
    
}
