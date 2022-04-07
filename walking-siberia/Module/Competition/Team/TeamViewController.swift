import UIKit

class TeamViewController: ViewController<TeamView> {
    
    private var team: Team
    private let competition: Competition
    private let provider = TeamProvider()
    
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
        mainView.contentView.actionButton.addTarget(self, action: #selector(action), for: .touchUpInside)
        mainView.contentView.deleteTeamButton.addTarget(self, action: #selector(deleteTeamAction), for: .touchUpInside)
        
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateTeam()
    }
    
    private func configure() {
        mainView.navBar.title = team.name
        
        mainView.contentView.participantsStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        team.users.enumerated().forEach { user in
            let participantView = ParticipantView()
            let fullName = "\(user.element.user.profile.firstName) \(user.element.user.profile.lastName)"
            participantView.nameLabel.text = fullName
            let userCategory: UserCategory? = .init(rawValue: user.element.user.type)
            participantView.categoryLabel.text = userCategory?.categoryName
            
            var text = R.string.localizable.stepsCount(number: user.element.statistics.total.number, preferredLanguages: ["ru"])
            if user.element.statistics.total.number > 30000 {
                text = text.replacingOccurrences(of: "\(user.element.statistics.total.number)", with: user.element.statistics.total.number.roundedWithAbbreviations)
            }
            participantView.stepsCountLabel.text = text
            participantView.distanceLabel.text = "\(user.element.statistics.total.km) км"
            
            if let url = user.element.user.profile.avatar {
                ImageLoader.setImage(url: url, imgView: participantView.imageView)
            } else {
                participantView.imageView.image = UIImage.createWithBgColorFromText(text: fullName.getInitials(), color: .clear, circular: true, side: 48.0)
                participantView.gradientLayer = GradientHelper.shared.layer(userId: user.element.userId)
            }

            if team.ownerId == user.element.userId {
                participantView.layer.borderWidth = 1.0
            }
            
            participantView.tag = user.offset
            participantView.gestureRecognizers?.removeAll()
            participantView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openUserProfile)))
            
            mainView.contentView.participantsStackView.addArrangedSubview(participantView)
        }
        
        isOwner = team.ownerId == UserSettings.user?.userId
        if isOwner {
            mainView.contentView.actionButton.setTitle("Редактировать", for: .normal)
            mainView.contentView.deleteTeamButton.isHidden = false
        } else if team.isJoined {
            mainView.contentView.actionButton.setTitle("Покинуть команду", for: .normal)
        } else if !team.isClosed {
            mainView.contentView.actionButton.setTitle("Подать заявку в команду", for: .normal)
        }
        
        loadMyTeam()
    }
    
    private func updateTeam() {
        provider.updateTeam(teamId: team.id) { [weak self] result in
            guard let self = self else {
                return
            }
            
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
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let team):
                let competitionJoined = team?.competitionId == self.team.competitionId
                let isHidden = competitionJoined && !self.team.isJoined || self.competition.isClosed
                self.mainView.contentView.actionButton.isHidden = isHidden
                
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
            guard let self = self else {
                return
            }
            
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
            guard let self = self else {
                return
            }
            
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
            leaveTeam()
        } else {
            joinTeam()
        }
    }
    
    @objc private func deleteTeamAction() {
        dialog(title: "Удалить команду?", accessText: "Да", cancelText: "Нет", onAgree: { [weak self] _ in
            self?.deleteTeam()
        })
    }
    
    @objc private func openUserProfile(_ gestureRecognizer: UIGestureRecognizer) {
        guard let index = gestureRecognizer.view?.tag,
              team.users[index].userId != UserSettings.user?.userId
        else { return }
        
        navigationController?.pushViewController(UserProfileViewController(user: team.users[index].user), animated: true)
    }
    
}
