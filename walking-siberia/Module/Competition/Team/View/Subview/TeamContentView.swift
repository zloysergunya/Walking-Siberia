import UIKit
import SnapKit

class TeamContentView: RootView {
    
    let participantsStackView = UIStackView(views: [], spacing: 8.0)
    
    let actionButton: ActiveButton = {
        let button = ActiveButton()
        button.isHidden = true
        
        return button
    }()
    
    let deleteTeamButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Удалить команду", for: .normal)
        button.isHidden = true
        button.setTitleColor(R.color.activeElements(), for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1.0
        button.layer.borderColor = R.color.activeElements()?.cgColor
        
        return button
    }()
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(participantsStackView)
        addSubview(actionButton)
        addSubview(deleteTeamButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        participantsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(participantsStackView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(38.0)
        }
        
        deleteTeamButton.snp.makeConstraints { make in
            make.top.equalTo(actionButton.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().offset(-16.0)
            make.height.equalTo(38.0)
        }
        
    }
    
    
}
