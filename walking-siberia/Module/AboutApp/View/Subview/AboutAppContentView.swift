import UIKit
import SnapKit

class AboutAppContentView: RootView {
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaBold(size: 16.0)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let contactsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Контакты"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaBold(size: 16.0)
        
        return label
    }()
    
    private let phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Телефон:"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "E-mail:"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Адрес:"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.numberOfLines = 0
        
        return label
    }()

    override func setup() {
        
        addSubview(descriptionTitleLabel)
        addSubview(descriptionLabel)
        addSubview(contactsTitleLabel)
        addSubview(phoneTitleLabel)
        addSubview(phoneLabel)
        addSubview(emailTitleLabel)
        addSubview(emailLabel)
        addSubview(addressTitleLabel)
        addSubview(addressLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        contactsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(14.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        phoneTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contactsTitleLabel.snp.bottom).offset(4.0)
            make.left.equalToSuperview().offset(12.0)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(contactsTitleLabel.snp.bottom).offset(4.0)
            make.left.equalToSuperview().offset(74.0)
            make.right.equalToSuperview().offset(-12.0)
        }
        
        emailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTitleLabel.snp.bottom).offset(4.0)
            make.left.equalToSuperview().offset(12.0)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTitleLabel.snp.bottom).offset(4.0)
            make.left.equalToSuperview().offset(74.0)
            make.right.equalToSuperview().offset(-12.0)
        }
        
        addressTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(4.0)
            make.left.equalToSuperview().offset(12.0)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(4.0)
            make.left.equalToSuperview().offset(74.0)
            make.right.equalToSuperview().offset(-12.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
    }

}
