import UIKit
import SnapKit

class ProfileEditContentView: RootView {
    
    private let photoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    var gradientLayer: CAGradientLayer? {
        didSet {
            if let gradientLayer = gradientLayer {
                imageViewBackgroundView.layer.addSublayer(gradientLayer)
            }
        }
    }
    
    let imageViewBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 60.0
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60.0
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let changePhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Изменить фото"
        label.font = R.font.geometriaBold(size: 12.0)
        label.textColor = R.color.activeElements()
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let personalInfoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let personalInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Личная информация"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaBold(size: 20.0)
        
        return label
    }()
    
    let personalInfoEditButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.editFill24(), for: .normal)
        button.titleLabel?.font = R.font.geometriaBold(size: 14.0)
        button.setTitleColor(R.color.activeElements(), for: .normal)
        button.tintColor = R.color.activeElements()
        
        return button
    }()
    
    let nameTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.title = "Имя"
        textField.placeholder = textField.title
        textField.isUserInteractionEnabled = false
        textField.textContentType = .givenName
        textField.setTitleVisible(true)
        
        return textField
    }()
    
    let surnameTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.title = "Фамилия"
        textField.placeholder = textField.title
        textField.isUserInteractionEnabled = false
        textField.textContentType = .familyName
        textField.setTitleVisible(true)
        
        return textField
    }()
    
    let cityTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.title = "Город"
        textField.placeholder = textField.title
        textField.isUserInteractionEnabled = false
        textField.textContentType = .addressCity
        textField.setTitleVisible(true)
        
        return textField
    }()
    
    let birthdayTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.title = "Дата рождения"
        textField.placeholder = "XX.XX.XXXX"
        textField.isUserInteractionEnabled = false
        textField.setTitleVisible(true)
        
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
    
    let manWithHIAView: ManWithHIAView = {
        let view = ManWithHIAView()
        view.checkBox.isUserInteractionEnabled = false
        
        return view
    }()
    
    let heightTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.title = "Рост, см"
        textField.placeholder = textField.title
        textField.isUserInteractionEnabled = false
        textField.keyboardType = .decimalPad
        textField.setTitleVisible(true)
        
        return textField
    }()
    
    let weightTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.title = "Вес, кг"
        textField.placeholder = textField.title
        textField.isUserInteractionEnabled = false
        textField.keyboardType = .decimalPad
        textField.setTitleVisible(true)
        
        return textField
    }()
    
    private lazy var heightAndWeightStackView = UIStackView(views: [
        heightTextField,
        weightTextField
    ], axis: .horizontal, spacing: 16.0)
    
    let phoneTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.title = "Номер телефона"
        textField.placeholder = "+7 (ХХХ) ХХХ ХХ ХХ"
        textField.isUserInteractionEnabled = false
        textField.keyboardType = .phonePad
        textField.setTitleVisible(true)
        
        return textField
    }()
    
    let emailTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.title = "E-mail"
        textField.placeholder = textField.title
        textField.isUserInteractionEnabled = false
        textField.textContentType = .emailAddress
        textField.setTitleVisible(true)
        
        return textField
    }()
    
    let bioTextField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.title = "О себе"
        textField.placeholder = textField.title
        textField.isUserInteractionEnabled = false
        textField.setTitleVisible(true)
        
        return textField
    }()
    
    private let socialLinksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ссылки на соц. сети"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        
        return label
    }()
    
    let telegramField: StyledTextField = {
        let textField = StyledTextField()
        textField.leftView = UIImageView(image: R.image.telegramIcon20())
        textField.placeholder = "Telegram"
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    let instagramField: StyledTextField = {
        let textField = StyledTextField()
        textField.leftView = UIImageView(image: R.image.instagramIcon20())
        textField.placeholder = "Instagram"
        textField.isUserInteractionEnabled = false
        textField.isHidden = true
        
        return textField
    }()
    
    let vkField: StyledTextField = {
        let textField = StyledTextField()
        textField.leftView = UIImageView(image: R.image.vkIcon20())
        textField.placeholder = "ВКонтакте"
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    let okField: StyledTextField = {
        let textField = StyledTextField()
        textField.leftView = UIImageView(image: R.image.okIcon20())
        textField.placeholder = "Одноклассники"
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    private lazy var socialLinksStackView = UIStackView(views: [
        socialLinksTitleLabel,
        telegramField,
        instagramField,
        vkField,
        okField
    ], distribution: .fillProportionally)
    
    private lazy var personalInfoStackView = UIStackView(views: [
        nameTextField,
        surnameTextField,
        cityTextField,
        birthdayTextField,
        manWithHIAView,
        heightAndWeightStackView,
        phoneTextField,
        emailTextField,
        bioTextField,
        socialLinksStackView
    ], spacing: 8.0, distribution: .fill)
    
    private let notifySettingsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let notifySettingsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Уведомления"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaBold(size: 20.0)
        
        return label
    }()
    
    let routesNotifyActionView = ProfileEditCellView(title: "Маршруты", iconType: .switcher)
    let competitionsNotifyActionView = ProfileEditCellView(title: "Соревнования", iconType: .switcher)
    let infoNotifyActionView = ProfileEditCellView(title: "Раздел информации", iconType: .switcher)
    
    private lazy var notifySettingsStackView = UIStackView(views: [
        routesNotifyActionView,
        competitionsNotifyActionView,
        infoNotifyActionView
    ])
    
    private let otherContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let otherTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Прочее"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaBold(size: 20.0)
        
        return label
    }()
    
    let instructionActionView = ProfileEditCellView(title: "Инструкция", iconType: .arrow)
    let aboutAppActionView = ProfileEditCellView(title: "О приложении", iconType: .arrow)
    let writeToDevelopersActionView = ProfileEditCellView(title: "Написать разработчикам", iconType: .arrow)
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти из приложения", for: .normal)
        button.setTitleColor(.init(hex: 0xE4302B), for: .normal)
        button.titleLabel?.font = R.font.geometriaBold(size: 16.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    let deleteUserButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить аккаунт", for: .normal)
        button.setTitleColor(.init(hex: 0xE4302B), for: .normal)
        button.titleLabel?.font = R.font.geometriaBold(size: 16.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    private lazy var otherStackView = UIStackView(views: [
        instructionActionView,
        aboutAppActionView,
        writeToDevelopersActionView,
        deleteUserButton,
        logoutButton
    ])

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(photoContainerView)
        addSubview(personalInfoContainerView)
        addSubview(notifySettingsContainerView)
        addSubview(otherContainerView)
        
        photoContainerView.addSubview(imageViewBackgroundView)
        photoContainerView.addSubview(avatarImageView)
        photoContainerView.addSubview(changePhotoLabel)
        
        personalInfoContainerView.addSubview(personalInfoTitleLabel)
        personalInfoContainerView.addSubview(personalInfoEditButton)
        personalInfoContainerView.addSubview(personalInfoStackView)
        
        notifySettingsContainerView.addSubview(notifySettingsTitleLabel)
        notifySettingsContainerView.addSubview(notifySettingsStackView)
        
        otherContainerView.addSubview(otherTitleLabel)
        otherContainerView.addSubview(otherStackView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        // MARK: - Photo container
        photoContainerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        imageViewBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(avatarImageView.snp.edges)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(120.0)
        }
        
        changePhotoLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
        // MARK: - Personal info container
        personalInfoContainerView.snp.makeConstraints { make in
            make.top.equalTo(photoContainerView.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
        }
        
        personalInfoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.left.equalToSuperview().offset(12.0)
        }
        
        personalInfoEditButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-12.0)
            make.height.equalTo(24.0)
        }
        
        personalInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(personalInfoTitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview()
        }
        
        // MARK: - Notify settings container
        notifySettingsContainerView.snp.makeConstraints { make in
            make.top.equalTo(personalInfoContainerView.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
        }
        
        notifySettingsTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.left.equalToSuperview().offset(12.0)
        }
        
        notifySettingsStackView.snp.makeConstraints { make in
            make.top.equalTo(notifySettingsTitleLabel.snp.bottom).offset(8.0)
            make.left.bottom.right.equalToSuperview()
        }
        
        // MARK: - Other container
        otherContainerView.snp.makeConstraints { make in
            make.top.equalTo(notifySettingsContainerView.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
        otherTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.left.equalToSuperview().offset(12.0)
        }
        
        otherStackView.snp.makeConstraints { make in
            make.top.equalTo(otherTitleLabel.snp.bottom).offset(8.0)
            make.left.bottom.right.equalToSuperview()
        }
        
    }
    
}
