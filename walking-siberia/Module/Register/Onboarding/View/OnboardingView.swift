import UIKit
import SnapKit
import Atributika

class SignInButton: UIButton {
    
    enum SignInType {
        case phone, apple, google
    }
    
    private let signInType: SignInType
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 40.0)
    }
    
    init(signInType: SignInType) {
        self.signInType = signInType
        super.init(frame: .zero)
        
        contentHorizontalAlignment = .left
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        titleLabel?.font = R.font.geometriaBold(size: 12.0)
        setTitleColor(R.color.mainContent(), for: .normal)
        backgroundColor = .clear
        layer.cornerRadius = 5.0
        layer.borderColor = R.color.activeElements()?.cgColor
        layer.borderWidth = 1.0
        
        switch signInType {
        case .phone:
            setTitle("Вход по номеру телефона", for: .normal)
            setImage(R.image.signInByPhone(), for: .normal)

        case .apple:
            setTitle("Продолжить с Apple", for: .normal)
            setImage(R.image.signInByApple(), for: .normal)
            
        case .google:
            setTitle("Использовать аккаунт Google", for: .normal)
            setImage(R.image.signInByGoogle(), for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageSize = currentImage?.size ?? .zero
        let availableWidth = contentRect.width - imageEdgeInsets.right - imageSize.width - titleRect.width

        return titleRect.offsetBy(dx: round(availableWidth / 2), dy: 0)
    }
    
}

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
    
    let signInByPhoneButton = SignInButton(signInType: .phone)
    let signInByAppleButton = SignInButton(signInType: .apple)
    let signInByGoogleButton = SignInButton(signInType: .google)
    
    private lazy var signInButtonsStackView = UIStackView(views: [
//        signInByPhoneButton,
        signInByAppleButton,
        signInByGoogleButton
    ], spacing: 8.0)
    
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
        addSubview(signInButtonsStackView)
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
            make.bottom.equalTo(signInButtonsStackView.snp.top).offset(-16.0)
        }
        
        signInButtonsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        policyLabel.snp.makeConstraints { make in
            make.top.equalTo(signInButtonsStackView.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
    }

}
