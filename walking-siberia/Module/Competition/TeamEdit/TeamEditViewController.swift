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

    private var type: EditType
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
    
    init(type: EditType) {
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
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        loadUsers(flush: true)
    }
    
    private func configure() {
        switch type {
        case .create:
            mainView.navBar.title = "Создание команды"
            
        case .edit(let team):
            teamName = team.name
            isTeamClosed = team.isClosed
            mainView.navBar.title = "Редактирование команды"
        }
        
        mainView.addParticipantsButton.isHidden = type == .create
    }
    
    private func loadUsers(flush: Bool) {
        guard loadingState != .loading, case .edit(let team) = type else { return }
        
        loadingState = .loading
        
        if flush {
            provider.page = 1
        }
        
        provider.loadParticipants(teamId: team.id, disabled: team.isDisabled) { [weak self] result in
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
        let teamCreateRequest = TeamCreateRequest(name: teamName,
                                                  status: status,
                                                  userIds: users.map({ $0.userId }))
        provider.createTeam(teamCreateRequest: teamCreateRequest) { [weak self] result in
            switch result {
            case .success(let team):
                self?.type = .edit(team: team)
                self?.addParticipants()
                self?.configure()
                self?.delegate?.teamEditViewController(didUpdate: team)

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
    
    private func deleteUser(userId: Int, completion: @escaping(Bool) -> Void) {
        guard case .edit(let team) = type else { return }
        
        provider.deleteUser(teamId: team.id, userId: userId) { [weak self] result in
            switch result {
            case .success:
                completion(true)
                
            case .failure(let error):
                completion(false)
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addParticipants() {
        guard case .edit(let team) = type else { return }
        
        let viewController = FindFriendsViewController(teamId: team.id)
        navigationController?.pushViewController(viewController, animated: true)
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
    
    func teamEditSectionController(didChange teamName: String) {
        self.teamName = teamName
    }
    
    func teamEditSectionController(didChange isTeamClosed: Bool) {
        self.isTeamClosed = isTeamClosed
    }
    
    func teamEditSectionController(didSelectAction button: UIButton, user: User) {        
        Utils.impact()
        deleteUser(userId: user.userId) { [weak self] success in
            if success, let index = self?.users.firstIndex(where: { $0.userId == user.userId }) {
                self?.users.remove(at: index)
                self?.adapter.performUpdates(animated: true)
            }
        }
    }
    
    func teamEditSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= users.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadUsers(flush: false)
        }
    }
}
