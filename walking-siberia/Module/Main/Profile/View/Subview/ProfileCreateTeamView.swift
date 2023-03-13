import UIKit
import SnapKit

final class ProfileCreateTeamView: RootView {
    
    let actionButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Создать команду", for: .normal)
        
        return button
    }()
    
    override func setup() {
        backgroundColor = .white
        
        addSubview(actionButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        actionButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
    }
    
}
