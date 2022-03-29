import UIKit
import SnapKit

class TrainerCell: UICollectionViewCell {
    
    var gradientLayer: CAGradientLayer? {
        didSet {
            if let gradientLayer = gradientLayer {
                imageViewBackgroundView.layer.addSublayer(gradientLayer)
            }
        }
    }
    
    let imageViewBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30.0
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 10.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 2
        
        return label
    }()
    
    private let placeOfTrainingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Место тренировок:"
        label.font = R.font.geometriaBold(size: 12.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let placeOfTrainingLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 2
        
        return label
    }()
    
    private let timeOfTrainingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Время тренировок:"
        label.font = R.font.geometriaBold(size: 12.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let timeOfTrainingLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 2
        
        return label
    }()
    
    private let phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Номер телефона:"
        label.font = R.font.geometriaBold(size: 12.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let callButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Позвонить тренеру", for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16.0
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageViewBackgroundView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(positionLabel)
        contentView.addSubview(placeOfTrainingTitleLabel)
        contentView.addSubview(placeOfTrainingLabel)
        contentView.addSubview(timeOfTrainingTitleLabel)
        contentView.addSubview(timeOfTrainingLabel)
        contentView.addSubview(phoneTitleLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(callButton)
        
        addShadow()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer?.frame = imageViewBackgroundView.bounds
    }
    
    private func setupConstraints() {
        
        imageViewBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(imageView.snp.edges)
        }
        
        imageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12.0)
            make.size.equalTo(60.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-12.0)
            make.left.equalTo(imageView.snp.right).offset(8.0)
        }
        
        positionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            make.right.equalToSuperview().offset(-12.0)
            make.left.equalTo(imageView.snp.right).offset(8.0)
        }
        
        placeOfTrainingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        placeOfTrainingLabel.snp.makeConstraints { make in
            make.top.equalTo(placeOfTrainingTitleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        timeOfTrainingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(placeOfTrainingLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        timeOfTrainingLabel.snp.makeConstraints { make in
            make.top.equalTo(timeOfTrainingTitleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        phoneTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeOfTrainingLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTitleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        callButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(phoneLabel.snp.bottom).offset(8.0)
            make.left.right.bottom.equalToSuperview().inset(12.0)
            make.height.equalTo(38.0)
        }
        
    }
    
}
