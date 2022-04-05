import UIKit
import SnapKit

class CompetitionView: RootView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let teamsLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.activeElements()?.withAlphaComponent(0.5)
        
        return view
    }()
    
    private let arrowImageView = UIImageView(image: R.image.chevronRight24())
    
    override func setup() {
        isUserInteractionEnabled = true
        
        addSubview(nameLabel)
        addSubview(teamsLabel)
        addSubview(arrowImageView)
        addSubview(separator)
                
        super.setup()
    }
    
    override func setupConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.right.equalTo(arrowImageView.snp.left).offset(-16.0)
        }
        
        teamsLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            make.left.equalToSuperview()
            make.right.equalTo(arrowImageView.snp.left).offset(-16.0)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.size.equalTo(24.0)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(teamsLabel.snp.bottom).offset(8.0)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
    }
    
}
