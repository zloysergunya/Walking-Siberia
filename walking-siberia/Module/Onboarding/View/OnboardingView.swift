import UIKit
import SnapKit
import Atributika

class OnboardingView: RootView {
    
    private let logoImageView = UIImageView(image: R.image.logo())
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Авторизация"
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaBold(size: 20.0)
        
        return label
    }()
    
    let signInButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Вход по номеру телефона", for: .normal)
        button.isActive = true
        
        return button
    }()
    
    let policyLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.textColor = R.color.mainContent() ?? .black
        label.textAlignment = .center
        label.font = R.font.geometriaRegular(size: 12.0) ?? .systemFont(ofSize: 12.0)
        label.numberOfLines = 0
        
        return label
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(signInButton)
        addSubview(policyLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(120.0)
            make.width.equalTo(216.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalTo(signInButton.snp.top).offset(-16.0)
        }
        
        signInButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(38.0)
        }
        
        policyLabel.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
    }

}
