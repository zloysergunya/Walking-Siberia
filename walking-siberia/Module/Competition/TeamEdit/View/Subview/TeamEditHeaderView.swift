import UIKit
import SnapKit

class TeamEditHeaderView: UICollectionReusableView {
    
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
        view.switcherView.isUserInteractionEnabled = true
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = R.color.greyBackground()
        
        addSubview(nameTitleLabel)
        addSubview(nameField)
        addSubview(closeTeamView)
        addSubview(closeTeamDescriptionLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
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
            make.left.right.bottom.equalToSuperview().inset(12.0)
        }
    }
    
}
