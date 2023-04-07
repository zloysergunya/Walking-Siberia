import UIKit
import SnapKit

class RouteDescriptionView: RootView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = R.font.geometriaBold(size: 16.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 16.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
