import UIKit

class TeamEditViewController: ViewController<TeamEditView> {
    
    enum EditType: Equatable {
        case create
        case edit(team: Team)
    }

    private let competition: Competition
    private let type: EditType
    private let provider = TeamEditProvider()
    private let maxParticipantsCount = 5
    
    private var currentParticipants: [User] = []
    
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
        mainView.contentView.addParticipantsButton.addTarget(self, action: #selector(addParticipants), for: .touchUpInside)
        mainView.contentView.saveTeamButton.addTarget(self, action: #selector(saveTeam), for: .touchUpInside)
        
        switch type {
        case .create:
            mainView.navBar.title = "Создание команды"
            
        case .edit(let team):
            mainView.navBar.title = "Редактирование команды"
            mainView.contentView.nameField.text = team.name
            mainView.contentView.closeTeamView.switcherView.isOn = team.isClosed
            mainView.contentView.addParticipantsButton.isHidden = currentParticipants.count == maxParticipantsCount || competition.isClosed
            updateParticipants()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func updateParticipants() {
        mainView.contentView.participantsStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        currentParticipants.enumerated().forEach { user in
            let cell = FindFriendsCell()
            let fullName = "\(user.element.profile.firstName) \(user.element.profile.lastName)"
            cell.nameLabel.text = fullName
            
            if let url = user.element.profile.avatar {
                ImageLoader.setImage(url: url, imgView: cell.imageView)
            } else {
                cell.imageView.image = UIImage.createWithBgColorFromText(text: fullName.getInitials(), color: .clear, circular: true, side: 48.0)
                let gradientLayer = GradientHelper.shared.layer(userId: user.element.userId)
                gradientLayer?.frame = CGRect(side: 48.0)
                cell.gradientLayer = gradientLayer
            }
            
            cell.actionButton.isSelected = true
            cell.actionButton.isHidden = user.element.userId == UserSettings.user?.userId
            cell.actionButton.tag = user.offset
            cell.actionButton.addTarget(self, action: #selector(removeParticipant), for: .touchUpInside)
            
            if case .edit(let team) = type {
                cell.contentView.layer.borderWidth = team.ownerId == user.element.userId ? 1.0 : 0.0
            }
            
            cell.tag = user.offset
            cell.gestureRecognizers?.removeAll()
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openUserProfile)))
            
            mainView.contentView.participantsStackView.addArrangedSubview(cell)
        }
    }
    
    private func createTeam() {
        guard let name = mainView.contentView.nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            Animations.shake(view: mainView.contentView.nameField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            return
        }
        
        let status = mainView.contentView.closeTeamView.switcherView.isOn ? 1 : 0
        let teamCreateRequest = TeamCreateRequest(competitionId: competition.id,
                                                  name: name,
                                                  status: status,
                                                  userIds: currentParticipants.map({ $0.userId }))
        provider.createTeam(teamCreateRequest: teamCreateRequest) { [weak self] result in
            switch result {
            case .success:
                self?.close()
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func updateTeam() {
        guard case .edit(let team) = type else {
            return
        }
        
        guard let name = mainView.contentView.nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            Animations.shake(view: mainView.contentView.nameField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            return
        }
        
        var userIds = currentParticipants.map({ $0.userId })
        if let index = currentParticipants.firstIndex(where: { $0.userId == UserSettings.user?.userId }) {
            userIds.remove(at: index)
        }
        
        let status = mainView.contentView.closeTeamView.switcherView.isOn ? 1 : 0
        let teamUpdateRequest = TeamUpdateRequest(teamId: team.id,
                                                  name: name,
                                                  status: status,
                                                  userIds: userIds)
        provider.updateTeam(teamUpdateRequest: teamUpdateRequest) { [weak self] result in
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
    
    @objc private func addParticipants() {
        let availableCount = 5 - currentParticipants.count
        guard availableCount > 0 else {
            showError(text: "Достигнуто максимальное число участников")
            
            return
        }
        
        if let index = currentParticipants.firstIndex(where: { $0.userId == UserSettings.user?.userId }) {
            currentParticipants.remove(at: index)
        }
        
        let viewController = FindFriendsViewController(availableCount: availableCount, currentParticipants: currentParticipants)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func saveTeam() {
        switch type {
        case .create: createTeam()
        case .edit: updateTeam()
        }
    }
    
    @objc private func removeParticipant(_ sender: UIButton) {
        Utils.impact()
        
        currentParticipants.remove(at: sender.tag)
        mainView.contentView.addParticipantsButton.isHidden = currentParticipants.count == maxParticipantsCount
        updateParticipants()
    }
    
    @objc private func openUserProfile(_ gestureRecognizer: UIGestureRecognizer) {
        guard let index = gestureRecognizer.view?.tag,
              currentParticipants[index].userId != UserSettings.user?.userId
        else { return }
        
        navigationController?.pushViewController(UserProfileViewController(userId: currentParticipants[index].userId), animated: true)
    }
    
}

// MARK: - FindFriendsViewControllerDelegate
extension TeamEditViewController: FindFriendsViewControllerDelegate {
    
    func findFriendsViewController(didSelect users: [User]) {
        currentParticipants = users
        
        if let user = UserSettings.user, type != .create {
            currentParticipants.insert(user, at: 0)
        }
        
        mainView.contentView.addParticipantsButton.isHidden = currentParticipants.count == maxParticipantsCount
        updateParticipants()
    }
    
}
