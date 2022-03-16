import UIKit
import SnapKit

class TeamEditContentView: RootView {
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Название"
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let nameField: StyledTextField = {
        let textField = StyledTextField()
        textField.placeholder = "Команда"
        
        return textField
    }()
    
    let closeTeamView: ProfileEditCellView = {
        let view = ProfileEditCellView(title: "Сделать команду закрытой", iconType: .switcher)
        view.switcherView.isOn = false
        view.separator.isHidden = true
        
        return view
    }()
    
    private let closeTeamDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "*Участниками закрытой команды могут быть только люди из списка друзей"
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    let participantsStackView = UIStackView(views: [], spacing: 8.0)
    
    let addParticipantsButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Добавить участников", for: .normal)
        
        return button
    }()
    
    let saveTeamButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Готово", for: .normal)
        
        return button
    }()
    
    private lazy var buttonStack = UIStackView(views: [
        addParticipantsButton,
        saveTeamButton
    ], spacing: 8.0)
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(participantsStackView)
        addSubview(nameTitleLabel)
        addSubview(nameField)
        addSubview(closeTeamView)
        addSubview(closeTeamDescriptionLabel)
        addSubview(buttonStack)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        nameTitleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(12.0)
        }
        
        nameField.snp.makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(24.0)
        }
        
        closeTeamView.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
        }
        
        closeTeamDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(closeTeamView.snp.bottom)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        participantsStackView.snp.makeConstraints { make in
            make.top.equalTo(closeTeamDescriptionLabel.snp.bottom).offset(20.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        addParticipantsButton.snp.makeConstraints { make in
            make.height.equalTo(38.0)
        }
        
        saveTeamButton.snp.makeConstraints { make in
            make.height.equalTo(38.0)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(participantsStackView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
    }
    
}
