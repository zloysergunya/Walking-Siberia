import UIKit
import SnapKit

class PhoneCodeAuthView: RootView {
    
    private let logoImageView = UIImageView(image: R.image.logo())
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код:"
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaBold(size: 16.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    var fieldsCount = 6 {
        didSet {
            oneTimeCodeField.configure(with: fieldsCount)
        }
    }
    
    private(set) lazy var oneTimeCodeField: OTPTextField = {
        let textField = OTPTextField()
        textField.otpFont = R.font.geometriaMedium(size: 18.0) ?? .systemFont(ofSize: 18.0)
        
        let primaryColor = R.color.activeElements() ?? .black
        let secondaryColor = R.color.greyText() ?? .gray
        
        textField.otpTextColor = primaryColor
        textField.otpFilledBorderColor = primaryColor
        textField.otpFilledBorderWidth = 1.0
        textField.otpDefaultBorderColor = secondaryColor
        textField.otpDefaultBorderWidth = 1.0
        textField.otpBackgroundColor = .clear
        textField.otpFilledBackgroundColor = .clear
        textField.configure(with: fieldsCount)
        
        return textField
    }()
    
    let resendCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaRegular(size: 12.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    let resendCodeButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Отправить код снова", for: .normal)
        button.isHidden = true
        
        return button
    }()
    
    var changePhoneButtonBottomConstraint: Constraint!
    let changePhoneButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Изменить номер", for: .normal)
        
        return button
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(oneTimeCodeField)
        addSubview(resendCodeLabel)
        addSubview(resendCodeButton)
        addSubview(changePhoneButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        logoImageView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(safeAreaLayoutGuide.snp.top).offset(24.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(120.0)
            make.width.equalTo(216.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(logoImageView.snp.bottom).offset(40.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        let side = 48.0
        let spacing = 8.0
        oneTimeCodeField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12.0)
            make.centerX.equalToSuperview()
            make.centerY.lessThanOrEqualToSuperview()
            make.width.equalTo(side * Double(fieldsCount) + spacing * Double(fieldsCount))
            make.height.equalTo(side)
        }
        
        resendCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(oneTimeCodeField.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.lessThanOrEqualTo(changePhoneButton.snp.top).offset(-12.0)
            make.height.equalTo(44.0)
        }
        
        resendCodeButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(oneTimeCodeField.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalTo(changePhoneButton.snp.top).offset(-12.0)
            make.height.equalTo(44.0)
        }
        
        changePhoneButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            changePhoneButtonBottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-26.0).constraint
            make.height.equalTo(44.0)
        }
        
    }
    
}
