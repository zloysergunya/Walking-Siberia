import UIKit
import PinLayout

class ExpertCell: UICollectionViewCell {
    
    enum Layout {
        static let avatarSide: CGFloat = 60.0
    }
    
    var gradientLayer: CAGradientLayer? {
        didSet {
            if let gradientLayer = gradientLayer {
                imageViewBackgroundView.layer.addSublayer(gradientLayer)
            }
        }
    }
    
    let imageViewBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Layout.avatarSide / 2
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Layout.avatarSide / 2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let specializationLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 2
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    private let phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Контакты:"
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
    
    private let chevronRightImageView = UIImageView(image: R.image.chevronRight24())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16.0
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageViewBackgroundView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(specializationLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(phoneTitleLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(chevronRightImageView)
                
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
        imageView.pin
            .top(10.0)
            .left(12.0)
            .size(Layout.avatarSide)
        
        imageViewBackgroundView.frame = imageView.frame
        gradientLayer?.frame = imageViewBackgroundView.bounds
        
        nameLabel.pin
            .after(of: imageView).marginLeft(8.0)
            .top(12.0)
            .right(12.0)
            .sizeToFit(.widthFlexible)
        
        specializationLabel.pin
            .after(of: imageView).marginLeft(8.0)
            .below(of: nameLabel).marginTop(4.0)
            .right(12.0)
            .sizeToFit(.widthFlexible)
        
        chevronRightImageView.pin
            .height(24.0)
            .width(24.0)
            .right(12.0)
            .vCenter()
        
        descriptionLabel.pin
            .below(of: imageView).marginTop(12.0)
            .left(12.0)
            .before(of: chevronRightImageView).marginRight(12.0)
            .sizeToFit(.widthFlexible)
        
        phoneTitleLabel.pin
            .below(of: descriptionLabel).marginTop(12.0)
            .left(12.0)
            .right(12.0)
            .sizeToFit(.widthFlexible)
        
        phoneLabel.pin
            .below(of: phoneTitleLabel).marginTop(8.0)
            .left(12.0)
            .right(12.0)
            .sizeToFit(.widthFlexible)
        
        contentView.pin.height(phoneLabel.frame.maxY + 12.0)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        
        return contentView.frame.size
    }
    
}
