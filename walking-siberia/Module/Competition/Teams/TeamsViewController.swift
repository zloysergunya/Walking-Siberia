import UIKit
import IGListKit

class TeamsViewController: ViewController<TeamsView> {
    
    enum CompetitionType {
        case team, single
    }
    
    private var competition: Competition
    private let competitionType: CompetitionType
    private let provider = TeamsProvider()
    
    private var query: String = ""
    private var pendingRequestWorkItem: DispatchWorkItem?
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
        
        mainView.searchBar.delegate = self
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        configure()
        loadTeams(flush: true)
        updateCompetition()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pullToRefresh), name: .userDidUpdate, object: nil)
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
            isCompetitionStarted = fromDate < Date()
        }

        let isDisabled = UserSettings.user?.isDisabled ?? false
        let isCompetitionUnavailable = competition.isClosed || isCompetitionStarted
        mainView.createTeamButton.isHidden = isDisabled || competitionType == .single || isCompetitionUnavailable || competition.isJoined
        mainView.takePartButton.isHidden = !isDisabled || competitionType == .team || isCompetitionUnavailable
        
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

        provider.loadTeams(uid: competition.id, searchText: query, isDisabled: competitionType == .single)  { [weak self] result in
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
                self.objects.insert(TeamSectionModel(team: team, isDisabled: self.competitionType == .single), at: 1)
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
        updateCompetition()
        loadTeams(flush: true)
    }
    
    @objc private func openCreateTeam() {
        let viewController = TeamEditViewController(competition: competition, type: .create)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
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
            let viewController = TeamViewController(team: team, competition: competition)
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func teamsSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= objects.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadTeams(flush: false)
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension TeamsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard query != searchText.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else {
                return
            }
            
            if searchText.isEmpty {
                self.query = ""
            } else {
                self.query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            self.loadTeams(flush: true)
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
    }
    
}

// MARK: - TeamViewControllerDelegate
extension TeamsViewController: TeamViewControllerDelegate {
    
    func teamViewController(didUpdate team: Team) {
        if let index = objects.firstIndex(where: { $0.team?.id == team.id }) {
            objects[index] = .init(team: team, isDisabled: objects[index].isDisabled)
            adapter.performUpdates(animated: true)
        }
    }
    
    func teamViewController(didDelete teamId: Int) {
        if let index = objects.firstIndex(where: { $0.team?.id == teamId }) {
            objects.remove(at: index)
            adapter.performUpdates(animated: true)
        }
    }
    
}

// MARK: - TeamEditViewControllerDelegate
extension TeamsViewController: TeamEditViewControllerDelegate {
    
    func teamEditViewController(didUpdate team: Team) {
        objects.insert(.init(team: team, isDisabled: competitionType == .single), at: 1)
        adapter.performUpdates(animated: true)
    }
    
}
