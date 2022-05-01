import UIKit
import SnapKit

class AccountRegisterSecondaryView: RootView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание аккаунта (2/2)"
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaBold(size: 16.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let addPhotoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавьте фото"
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaBold(size: 16.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    let addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.add72(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = R.color.greyLight()
        button.layer.cornerRadius = 56.0
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let bioTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "О себе"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        
        return label
    }()
    
    let bioField: StyledTextField = {
        let textField = StyledTextField()
        textField.placeholder = "Расскажите о себе"
        
        return textField
    }()
    
    private let socialLinksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ссылки на соц.сети:"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        
        return label
    }()
    
    let telegramField: StyledTextField = {
        let textField = StyledTextField()
        textField.leftView = UIImageView(image: R.image.telegramIcon20())
        textField.placeholder = "Telegram"
        
        return textField
    }()
    
    let instagramField: StyledTextField = {
        let textField = StyledTextField()
        textField.leftView = UIImageView(image: R.image.instagramIcon20())
        textField.placeholder = "Instagram"
        
        return textField
    }()
    
    private lazy var firstSocialLinksStackView = UIStackView(views: [
        telegramField,
//        instagramField
    ], axis: .horizontal, spacing: 12.0)
    
    let vkField: StyledTextField = {
        let textField = StyledTextField()
        textField.leftView = UIImageView(image: R.image.vkIcon20())
        textField.placeholder = "ВКонтакте"
        
        return textField
    }()
    
    let okField: StyledTextField = {
        let textField = StyledTextField()
        textField.leftView = UIImageView(image: R.image.okIcon20())
        textField.placeholder = "Одноклассники"
        
        return textField
    }()
    
    private lazy var secondSocialLinksStackView = UIStackView(views: [
        vkField,
        okField
    ], axis: .horizontal, spacing: 12.0)
    
    private lazy var socialLinksContainerStackView = UIStackView(views: [
        firstSocialLinksStackView,
        secondSocialLinksStackView
    ], spacing: 16.0)
    
    private let heightAndWeightTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Рост и вес:"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        
        return label
    }()
    
    let heightField: StyledTextField = {
        let textField = StyledTextField()
        textField.keyboardType = .decimalPad
        textField.placeholder = "Рост, см"
        
        return textField
    }()
    
    let weightField: StyledTextField = {
        let textField = StyledTextField()
        textField.keyboardType = .decimalPad
        textField.placeholder = "Вес, кг"
        
        return textField
    }()
    
    private lazy var heightAndWeighContainerStackView = UIStackView(views: [
        heightField,
        weightField
    ], axis: .horizontal, spacing: 12.0)
    
    let continueButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Пропустить", for: .normal)
        
        return button
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(titleLabel)
        addSubview(addPhotoTitleLabel)
        addSubview(addPhotoButton)
        addSubview(bioTitleLabel)
        addSubview(bioField)
        addSubview(socialLinksTitleLabel)
        addSubview(socialLinksContainerStackView)
        addSubview(heightAndWeightTitleLabel)
        addSubview(heightAndWeighContainerStackView)
        addSubview(continueButton)
                
        super.setup()
    }
    
    override func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(18.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        addPhotoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(addPhotoTitleLabel.snp.bottom).offset(8.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(112.0)
        }
        
        bioTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(20.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        bioField.snp.makeConstraints { make in
            make.top.equalTo(bioTitleLabel.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(36.0)
        }
        
        socialLinksTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bioField.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        socialLinksContainerStackView.snp.makeConstraints { make in
            make.top.equalTo(socialLinksTitleLabel.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        firstSocialLinksStackView.snp.makeConstraints { make in
            make.height.equalTo(22.0)
        }
        
        heightAndWeightTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(socialLinksContainerStackView.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        heightAndWeighContainerStackView.snp.makeConstraints { make in
            make.top.equalTo(heightAndWeightTitleLabel.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(22.0)
        }
        
        continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            make.height.equalTo(44.0)
        }
        
    }
    
}
