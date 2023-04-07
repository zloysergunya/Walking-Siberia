import UIKit
import SnapKit

class CompetitionView: RootView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    let teamLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaBold(size: 12.0)
        label.textColor = R.color.greyText()
        label.numberOfLines = 0
        
        return label
    }()
    
    let placeLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaBold(size: 12.0)
        label.textColor = R.color.graphicBlue()
        
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.activeElements()?.withAlphaComponent(0.5)
        
        return view
    }()
        
    override func setup() {
        isUserInteractionEnabled = true
        
        addSubview(nameLabel)
        addSubview(teamLabel)
        addSubview(placeLabel)
        addSubview(separator)
                
        super.setup()
    }
    
    override func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.right.equalToSuperview().offset(-16.0)
        }
        
        teamLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-16.0)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(teamLabel.snp.bottom).offset(4.0)
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-16.0)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(8.0)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }
    
}
