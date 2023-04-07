import UIKit
import IGListKit

protocol TeamViewControllerDelegate: AnyObject {
    func teamViewController(didUpdate team: Team)
    func teamViewController(didDelete teamId: Int)
}

class TeamViewController: ViewController<TeamView> {
    
    weak var delegate: TeamViewControllerDelegate?
    
    private var team: Team
    private var competition: Competition?
    private let provider = TeamProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var users: [Participant] = []
    private var isOwner = false
    private var hasAnotherTeam = false
    private var loadingState: LoadingState = .none {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }

    init(team: Team, competition: Competition?) {
        self.team = team
        self.competition = competition
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navBar.leftButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.actionButton.addTarget(self, action: #selector(action), for: .touchUpInside)
        mainView.deleteTeamButton.addTarget(self, action: #selector(deleteTeamAction), for: .touchUpInside)
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        mainView.navBar.title = team.name
        
        loadUsers(flush: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateTeam()
    }
    
    private func configure() {
        updateButtonsState()
    }
    
    private func loadUsers(flush: Bool) {
        guard loadingState != .loading else { return }
        
        loadingState = .loading
        
        if flush {
            provider.page = 1
        }
        
        provider.loadParticipants(teamId: team.id, competitionsId: competition?.id, disabled: team.isDisabled) { [weak self] result in
            guard let self = self else { return }
            
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
    
    private func updateTeam() {
        provider.updateTeam(teamId: team.id, competitionsId: competition?.id) { [weak self] result in
            switch result {
            case .success(let team):
                self?.team = team
                self?.delegate?.teamViewController(didUpdate: team)
                self?.loadUserTeam()
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }

    private func loadUserTeam() {
        provider.loadUserTeam { [weak self] result in
            switch result {
            case .success(let team):
                if let team {
                    self?.hasAnotherTeam = team.id != self?.team.id
                }
                self?.configure()
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func updateButtonsState() {
        isOwner = team.ownerId == UserSettings.user?.userId
        if isOwner {
            mainView.actionButton.setTitle("Редактировать", for: .normal)
            mainView.actionButton.isHidden = false
            mainView.deleteTeamButton.isHidden = false
        } else if team.isJoined {
            mainView.actionButton.setTitle("Покинуть команду", for: .normal)
            mainView.actionButton.isHidden = false
        } else if !team.isClosed && UserSettings.user?.isDisabled != true, !hasAnotherTeam {
            mainView.actionButton.setTitle("Подать заявку в команду", for: .normal)
            mainView.actionButton.isHidden = false
        } else {
            mainView.actionButton.isHidden = true
        }
    }
    
    private func openTeamEdit() {
        let viewController = TeamEditViewController(type: .edit(team: team))
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func joinTeam() {
        provider.joinTeam(teamId: team.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                if let user = UserSettings.user {
                    let participant = Participant(
                        userId: user.userId,
                        teamId: self.team.id,
                        createdAt: self.team.createAt,
                        user: user,
                        statistics: nil
                    )
                    
                    self.users.append(participant)
                }
                
                self.team.isJoined = true
                self.delegate?.teamViewController(didUpdate: self.team)
                self.configure()
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func leaveTeam() {
        provider.leaveTeam(teamId: team.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                if let index = self.users.firstIndex(where: { $0.userId == UserSettings.user?.userId }) {
                    self.users.remove(at: index)
                }
                
                self.team.isJoined = false
                self.delegate?.teamViewController(didUpdate: self.team)
                self.configure()
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func deleteTeam() {
        provider.deleteTeam(teamId: team.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.delegate?.teamViewController(didDelete: self.team.id)
                self.close()
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func action() {
        if isOwner {
            openTeamEdit()
        } else if team.isJoined {
            dialog(title: "Покинуть команду?",
                   message: "",
                   accessText: "Да",
                   cancelText: "Нет",
                   onAgree:  { [weak self] _ in
                self?.leaveTeam()
            })
        } else {
            joinTeam()
        }
    }
    
    @objc private func deleteTeamAction() {
        dialog(title: "Удалить команду?",
               accessText: "Да",
               cancelText: "Нет",
               onAgree: { [weak self] _ in
            self?.deleteTeam()
        })
    }
    
    @objc private func openUserProfile(_ gestureRecognizer: UIGestureRecognizer) {
        guard let index = gestureRecognizer.view?.tag,
              users[index].userId != UserSettings.user?.userId
        else { return }
        
        
    }
    
    @objc private func pullToRefresh() {
        loadUsers(flush: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension TeamViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return users.map({ TeamParticipantSectionModel(user: $0, team: team) })
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = TeamSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: loadingState)
    }
    
}

// MARK: - TeamSectionControllerDelegate
extension TeamViewController: TeamSectionControllerDelegate {
    
    func teamSectionController(didSelect user: Participant) {
        guard user.userId != UserSettings.user?.userId else { return }
        
        let viewController = UserProfileViewController(userId: user.user.userId)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func teamSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= users.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadUsers(flush: false)
        }
    }
    
}

// MARK: - TeamEditViewControllerDelegate
extension TeamViewController: TeamEditViewControllerDelegate {
    
    func teamEditViewController(didUpdate team: Team) {
        self.team = team
        configure()
        loadUsers(flush: true)
    }
    
}
