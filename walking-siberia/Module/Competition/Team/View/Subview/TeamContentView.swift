import UIKit
import SnapKit

class TeamContentView: RootView {
    
    let participantsStackView = UIStackView(views: [], spacing: 8.0)
    
    let actionButton: ActiveButton = {
        let button = ActiveButton()
        button.isHidden = true
        
        return button
    }()
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(participantsStackView)
        addSubview(actionButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        participantsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(participantsStackView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().offset(-16.0)
            make.height.equalTo(38.0)
        }
        
    }
    
    
}
