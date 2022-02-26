import UIKit
import SnapKit

class ProfileContentView: RootView {
    
    let statsButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.chart28(), for: .normal)
        
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.settings24(), for: .normal)
        
        return button
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()

    let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.person88())
        imageView.layer.cornerRadius = 44.0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    let nothingWasFoundLabel: UILabel = {
        let label = UILabel()
        label.text = "Пока вы не приняли участие\nв соревнованиях"
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.greyText()
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(headerView)
        addSubview(statsButton)
        addSubview(settingsButton)
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(idLabel)
        addSubview(bioLabel)
        addSubview(nothingWasFoundLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        statsButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.left.equalToSuperview().offset(24.0)
            make.size.equalTo(28.0)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.right.equalToSuperview().offset(-24.0)
            make.size.equalTo(28.0)
        }
        
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(256.0)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(88.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
        nothingWasFoundLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(64.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
    }
    
}
