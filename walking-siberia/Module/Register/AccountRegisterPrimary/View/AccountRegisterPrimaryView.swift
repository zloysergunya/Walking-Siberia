import UIKit
import SnapKit
import MBRadioButton

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
        textField.textContentType = .name
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
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория:"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        
        return label
    }()
    
    let schoolchildRadioButton: RadioButton = {
        let radioButton = RadioButton()
        radioButton.setTitle("Дети (6+)", for: .normal)
        radioButton.setTitleColor(R.color.mainContent(), for: .normal)
        radioButton.titleLabel?.font = R.font.geometriaMedium(size: 14.0)
        
        return radioButton
    }()
    
    let studentRadioButton: RadioButton = {
        let radioButton = RadioButton()
        radioButton.setTitle("Молодежь (16+)", for: .normal)
        radioButton.setTitleColor(R.color.mainContent(), for: .normal)
        radioButton.titleLabel?.font = R.font.geometriaMedium(size: 14.0)
        
        return radioButton
    }()
    
    let adultRadioButton: RadioButton = {
        let radioButton = RadioButton()
        radioButton.setTitle("Взрослые (30+)", for: .normal)
        radioButton.setTitleColor(R.color.mainContent(), for: .normal)
        radioButton.titleLabel?.font = R.font.geometriaMedium(size: 14.0)
        
        return radioButton
    }()
    
    let pensionerRadioButton: RadioButton = {
        let radioButton = RadioButton()
        radioButton.setTitle("Старшее поколение (65+)", for: .normal)
        radioButton.setTitleColor(R.color.mainContent(), for: .normal)
        radioButton.titleLabel?.font = R.font.geometriaMedium(size: 14.0)
        
        return radioButton
    }()
    
    let manWithHIARadioButton: RadioButton = {
        let radioButton = RadioButton()
        radioButton.setTitle("Человек с ОВЗ", for: .normal)
        radioButton.setTitleColor(R.color.mainContent(), for: .normal)
        radioButton.titleLabel?.font = R.font.geometriaMedium(size: 14.0)
        
        return radioButton
    }()
    
    let spacerRadioButton: RadioButton = {
        let radioButton = RadioButton()
        radioButton.setTitle("Пустое", for: .normal)
        radioButton.setTitleColor(R.color.mainContent(), for: .normal)
        radioButton.titleLabel?.font = R.font.geometriaMedium(size: 14.0)
        radioButton.alpha = 0
        
        return radioButton
    }()
    
    lazy var radioButtonsStackView = UIStackView(views: [
        schoolchildRadioButton,
        studentRadioButton,
        adultRadioButton,
        pensionerRadioButton,
        manWithHIARadioButton,
        spacerRadioButton
    ], spacing: 8.0)
    
    let continueButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Продолжить", for: .normal)
        button.isActive = false
        
        return button
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(titleLabel)
        addSubview(nameField)
        addSubview(surnameField)
        addSubview(cityField)
        addSubview(dateOfBirthTitleLabel)
        addSubview(dateOfBirthField)
        addSubview(emailTitleLabel)
        addSubview(emailField)
        addSubview(categoryTitleLabel)
        addSubview(radioButtonsStackView)
        addSubview(continueButton)
        
        super.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let underlineColor = R.color.greyText() ?? .gray
        nameField.underlined(color: underlineColor)
        surnameField.underlined(color: underlineColor)
        cityField.underlined(color: underlineColor)
        dateOfBirthField.underlined(color: underlineColor)
        emailField.underlined(color: underlineColor)
        
        radioButtonsStackView.arrangedSubviews.map({ $0 as? RadioButton }).forEach({
            $0?.radioCircle = RadioButtonCircleStyle(outerCircle: 16.0, innerCircle: 8.0, outerCircleBorder: 1.0, contentPadding: 4.0)
            $0?.radioButtonColor = RadioButtonColor(active: R.color.activeElements() ?? .blue, inactive: R.color.activeElements() ?? .blue)
        })
    }
    
    override func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(18.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        nameField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(24.0)
        }
        
        surnameField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(24.0)
        }
        
        cityField.snp.makeConstraints { make in
            make.top.equalTo(surnameField.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(24.0)
        }
        
        dateOfBirthTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(cityField.snp.bottom).offset(24.0)
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
         
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        radioButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        schoolchildRadioButton.snp.makeConstraints { make in
            make.height.equalTo(32.0)
        }
        
        continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            make.height.equalTo(44.0)
        }
        
    }
    
}
