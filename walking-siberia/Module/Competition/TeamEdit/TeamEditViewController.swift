import UIKit

class TeamEditViewController: ViewController<TeamEditView> {
    
    enum EditType {
        case create
        case edit(team: Team)
    }

    private let competition: Competition
    private let type: EditType
    private let provider = TeamEditProvider()
    
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
        
        mainView.contentView.addParticipantsButton.addTarget(self, action: #selector(addParticipants), for: .touchUpInside)
        mainView.contentView.saveTeamButton.addTarget(self, action: #selector(saveTeam), for: .touchUpInside)
        
        switch type {
        case .create:
            title = "Создание команды"
            
        case .edit(let team):
            title = "Редактирование команды"
            mainView.contentView.nameField.text = team.name
            
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
                                                  userIds: []) // TODO: добавить участников
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
        
        var userIds = team.users.map({ $0.userId })
        if let index = team.users.firstIndex(where: { $0.userId == UserSettings.user?.userId }) {
            userIds.remove(at: index)
        }
        
        let status = mainView.contentView.closeTeamView.switcherView.isOn ? 1 : 0
        let teamUpdateRequest = TeamUpdateRequest(teamId: team.id,
                                                  name: name,
                                                  status: status,
                                                  userIds: userIds) // TODO: добавить участников
        provider.updateTeam(teamUpdateRequest: teamUpdateRequest) { [weak self] result in
            switch result {
            case .success:
                self?.close()
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addParticipants() {
        
    }
    
    @objc private func saveTeam() {
        switch type {
        case .create: createTeam()
        case .edit: updateTeam()
        }
    }
    
}
