import UIKit
import SnapKit

class CompetitionPartnerView: RootView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 14.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.grey()
        
        return view
    }()

    override func setup() {
        addSubview(nameLabel)
        addSubview(separator)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8.0)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1.0)
        }

    }

}
