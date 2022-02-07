import UIKit
import SnapKit

class PhoneAuthView: RootView {
    
    private let logoImageView = UIImageView(image: R.image.logo())
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер телефона,\nмы отправим код подтверждения:"
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaBold(size: 16.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    let phoneTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.text = "+7"
        textField.placeholder = "+7 (ХХХ) ХХХ ХХ ХХ"
        textField.title = "Телефон"
        textField.keyboardType = .phonePad
        
        return textField
    }()
    
    var continueButtonBottomConstraint: Constraint!
    let continueButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Продолжить", for: .normal)
        button.isActive = false
        
        return button
    }()
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(phoneTextField)
        addSubview(continueButton)
        
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
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12.0)
            make.centerY.lessThanOrEqualToSuperview()
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.lessThanOrEqualTo(continueButton.snp.top).offset(-20.0)
            make.height.greaterThanOrEqualTo(44.0)
        }
            
        continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            continueButtonBottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-26.0).constraint
            make.height.equalTo(44.0)
        }
        
    }
    
}
