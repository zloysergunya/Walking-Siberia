import UIKit
import SnapKit

class UserCompetitionsView: RootView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaBold(size: 20.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    var rootStack = UIStackView(views: [], spacing: 8.0, distribution: .fill)
    
    override func setup() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(rootStack)
        
        super.setup()
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.left.right.equalToSuperview().inset(18.0)
        }
        
        rootStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(18.0)
            make.bottom.equalToSuperview().offset(-20.0)
        }
    }
    
}
