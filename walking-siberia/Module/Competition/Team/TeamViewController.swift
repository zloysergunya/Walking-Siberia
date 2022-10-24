import UIKit
import IGListKit

class TeamViewController: ViewController<TeamView> {
    
    private var team: Team
    private let competition: Competition
    private let provider = TeamProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    
    private var isOwner = false

    init(team: Team, competition: Competition) {
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
        
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateTeam()
    }
    
    private func configure() {
        mainView.navBar.title = team.name
        
        isOwner = team.ownerId == UserSettings.user?.userId
        if isOwner {
            mainView.actionButton.setTitle("Редактировать", for: .normal)
            mainView.actionButton.isHidden = false
            mainView.deleteTeamButton.isHidden = false
        } else if team.isJoined {
            mainView.actionButton.setTitle("Покинуть команду", for: .normal)
            mainView.actionButton.isHidden = false
        } else if !team.isClosed && team.users.count < 5 {
            mainView.actionButton.setTitle("Подать заявку в команду", for: .normal)
            mainView.actionButton.isHidden = false
        } else {
            mainView.actionButton.isHidden = true
        }
        
        loadMyTeam()
    }
    
    private func updateTeam() {
        provider.updateTeam(teamId: team.id) { [weak self] result in
            guard let self = self else { return }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let team):
                self.team = team
                self.configure()
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func loadMyTeam() {
        provider.loadMyTeam(competitionId: team.competitionId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let team):
                if let team = team {
                    let competitionJoined = team.competitionId == self.team.competitionId
                    let isHidden = competitionJoined && !self.team.isJoined || self.competition.isClosed
                    self.mainView.actionButton.isHidden = isHidden
                }
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func openTeamEdit() {
        navigationController?.pushViewController(TeamEditViewController(competition: competition, type: .edit(team: team)), animated: true)
    }
    
    private func joinTeam() {
        provider.joinTeam(teamId: team.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                if let user = UserSettings.user {
                    let participant = Participant(userId: user.userId,
                                                  teamId: self.team.id,
                                                  createdAt: self.team.createAt,
                                                  user: user,
                                                  statistics: ParticipantStatistics(total: Average(number: 0, km: 0.0), average: nil))
                    self.team.users.append(participant)
                }
                
                self.team.isJoined = true
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
                if let index = self.team.users.firstIndex(where: { $0.userId == UserSettings.user?.userId }) {
                    self.team.users.remove(at: index)
                }
                
                self.team.isJoined = false
                self.configure()
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func deleteTeam() {
        provider.deleteTeam(teamId: team.id) { [weak self] result in
            switch result {
            case .success:
                self?.close()
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
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
              team.users[index].userId != UserSettings.user?.userId
        else { return }
        
        
    }
    
    @objc private func pullToRefresh() {
        updateTeam()
    }
    
}

// MARK: - ListAdapterDataSource
extension TeamViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return team.users.map({ TeamParticipantSectionModel(user: $0, team: team) })
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = TeamSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: .loaded)
    }
    
}

// MARK: - TeamSectionControllerDelegate
extension TeamViewController: TeamSectionControllerDelegate {
    
    func teamSectionController(didSelect user: Participant) {
        guard user.userId != UserSettings.user?.userId else { return }
        
        let viewController = UserProfileViewController(user: user.user)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func teamSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        #warning("TODO: pagination")
    }
    
}
