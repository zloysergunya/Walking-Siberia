import UIKit
import SnapKit

final class UserProfileNoTeamView: RootView {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Пользователь не состоит в команде"
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    override func setup() {
        backgroundColor = .white
        
        addSubview(label)
        
        super.setup()
    }
    
    override func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
    }
    
}
