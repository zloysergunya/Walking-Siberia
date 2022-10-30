import UIKit
import IGListKit

protocol TeamEditViewControllerDelegate: AnyObject {
    func teamEditViewController(didUpdate team: Team)
}

class TeamEditViewController: ViewController<TeamEditView> {
    
    enum EditType: Equatable {
        case create
        case edit(team: Team)
    }
    
    weak var delegate: TeamEditViewControllerDelegate?

    private let competition: Competition
    private let type: EditType
    private let provider = TeamEditProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var users: [Participant] = []
    private var teamName = ""
    private var isTeamClosed: Bool = false
    private var loadingState: LoadingState = .none {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }
    
    init(competition: Competition, type: EditType) {
        self.competition = competition
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navBar.leftButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.addParticipantsButton.addTarget(self, action: #selector(addParticipants), for: .touchUpInside)
        mainView.saveTeamButton.addTarget(self, action: #selector(saveTeam), for: .touchUpInside)
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        switch type {
        case .create:
            mainView.navBar.title = "Создание команды"
            
        case .edit(let team):
            teamName = team.name
            isTeamClosed = team.isClosed
            mainView.navBar.title = "Редактирование команды"
            mainView.addParticipantsButton.isHidden = competition.isClosed
            loadUsers(flush: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func loadUsers(flush: Bool) {
        guard loadingState != .loading, case .edit(let team) = type else { return }
        
        loadingState = .loading
        
        if flush {
            provider.page = 1
        }
        
        provider.loadParticipants(teamId: team.id, disabled: team.isDisabled ?? false) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let users):
                if flush {
                    self.users.removeAll()
                }
                
                self.users.append(contentsOf: users)
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
            }
        }
    }
    
    private func createTeam() {
        guard !teamName.isEmpty else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)

            return
        }

        let status = isTeamClosed ? 1 : 0
        let teamCreateRequest = TeamCreateRequest(competitionId: competition.id,
                                                  name: teamName,
                                                  status: status,
                                                  userIds: users.map({ $0.userId }))
        provider.createTeam(teamCreateRequest: teamCreateRequest) { [weak self] result in
            switch result {
            case .success(let team):
                self?.delegate?.teamEditViewController(didUpdate: team)
                self?.close()

            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func updateTeam() {
        guard case .edit(let team) = type else { return }

        guard !teamName.isEmpty else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)

            return
        }

        var userIds = users.map({ $0.userId })
        if let index = users.firstIndex(where: { $0.userId == UserSettings.user?.userId }) {
            userIds.remove(at: index)
        }

        let status = isTeamClosed ? 1 : 0
        let teamUpdateRequest = TeamUpdateRequest(teamId: team.id,
                                                  name: teamName,
                                                  status: status,
                                                  userIds: userIds)
        provider.updateTeam(teamUpdateRequest: teamUpdateRequest) { [weak self] result in
            switch result {
            case .success(let team):
                self?.delegate?.teamEditViewController(didUpdate: team)
                self?.close()

            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addParticipants() {
//        let availableCount = 5 - currentParticipants.count
//        guard availableCount > 0 else {
//            showError(text: "Достигнуто максимальное число участников")
//
//            return
//        }
//
//        if let index = currentParticipants.firstIndex(where: { $0.userId == UserSettings.user?.userId }) {
//            currentParticipants.remove(at: index)
//        }
//
//        let viewController = FindFriendsViewController(availableCount: availableCount, currentParticipants: currentParticipants)
//        viewController.delegate = self
//        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func saveTeam() {
        switch type {
        case .create: createTeam()
        case .edit: updateTeam()
        }
    }
    
    @objc private func pullToRefresh() {
        loadUsers(flush: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension TeamEditViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        switch type {
        case .create:
            return [TeamEditSectionModel(users: users, team: nil)]
            
        case .edit(let team):
            return [TeamEditSectionModel(users: users, team: team)]
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = TeamEditSectionController()
        sectionController.delegate = self
        
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: loadingState)
    }
    
    
}

// MARK: - TeamEditSectionControllerDelegate
extension TeamEditViewController: TeamEditSectionControllerDelegate {

    func teamEditSectionController(didSelect user: Participant) {
        guard user.userId != UserSettings.user?.userId else { return }
        navigationController?.pushViewController(UserProfileViewController(userId: user.userId), animated: true)
    }
    
    func teamEditSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= users.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadUsers(flush: false)
        }
    }
    
    func teamEditSectionController(didChange teamName: String) {
        self.teamName = teamName
    }
    
    func teamEditSectionController(didChange isTeamClosed: Bool) {
        self.isTeamClosed = isTeamClosed
    }
    
}
// MARK: - FindFriendsViewControllerDelegate
extension TeamEditViewController: FindFriendsViewControllerDelegate {
    
    func findFriendsViewController(didSelect users: [User]) {
//        currentParticipants = users
//
//        if let user = UserSettings.user, type != .create {
//            currentParticipants.insert(user, at: 0)
//        }
//
//        updateParticipants()
    }
    
}
