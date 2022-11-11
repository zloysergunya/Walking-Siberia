import UIKit
import SnapKit

class AccountRegisterPrimaryView: RootView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание аккаунта (1/2)"
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaBold(size: 16.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    let nameField: StyledTextField = {
        let textField = StyledTextField()
        textField.textContentType = .givenName
        textField.placeholder = "Ваше имя"
        
        return textField
    }()
    
    let surnameField: StyledTextField = {
        let textField = StyledTextField()
        textField.textContentType = .familyName
        textField.placeholder = "Ваша фамилия"
        
        return textField
    }()
    
    let cityField: StyledTextField = {
        let textField = StyledTextField()
        textField.textContentType = .addressCity
        textField.placeholder = "Город"
        
        return textField
    }()
    
    let phoneField: StyledTextField = {
        let textField = StyledTextField()
        textField.textContentType = .telephoneNumber
        textField.keyboardType = .phonePad
        textField.text = "+7"
        textField.placeholder = "+7 (ХХХ) ХХХ ХХ ХХ"
        
        return textField
    }()
    
    private lazy var primaryFieldsStackView = UIStackView(views: [
        nameField,
        surnameField,
        cityField,
        phoneField
    ], spacing: 24.0)
    
    private let dateOfBirthTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата рождения:"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        
        return label
    }()
    
    let dateOfBirthField: StyledTextField = {
        let textField = StyledTextField()
        textField.placeholder = "XX.XX.XXXX"
        
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.setValue(UIColor.black, forKeyPath: "textColor")
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .clear
        datePicker.preferredDatePickerStyle = .wheels
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        datePicker.minimumDate = dateFormatter.date(from: "01.01.1900")
        
        var dateComponents = DateComponents()
        dateComponents.year = -6
        datePicker.maximumDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        
        return datePicker
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "E-mail:"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        
        return label
    }()
    
    let emailField: StyledTextField = {
        let textField = StyledTextField()
        textField.keyboardType = .emailAddress
        textField.textContentType = .emailAddress
        textField.autocapitalizationType = .none
        textField.placeholder = "mail@gmail.com"
        
        return textField
    }()
    
    let manWithHIAView: ManWithHIAView = {
        let view = ManWithHIAView()
        view.separator.isHidden = true
        
        return view
    }()
    
    let continueButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Продолжить", for: .normal)
        button.isActive = false
        
        return button
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(titleLabel)
        addSubview(primaryFieldsStackView)
        addSubview(dateOfBirthTitleLabel)
        addSubview(dateOfBirthField)
        addSubview(emailTitleLabel)
        addSubview(emailField)
        addSubview(manWithHIAView)
        addSubview(continueButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(18.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        primaryFieldsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        nameField.snp.makeConstraints { make in
            make.height.equalTo(24.0)
        }
        
        dateOfBirthTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(primaryFieldsStackView.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        dateOfBirthField.snp.makeConstraints { make in
            make.top.equalTo(dateOfBirthTitleLabel.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(24.0)
        }
        
        emailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateOfBirthField.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(24.0)
        }
        
        manWithHIAView.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            make.height.equalTo(44.0)
        }
        
    }
    
}
