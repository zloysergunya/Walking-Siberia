import UIKit
import PinLayout

class TrainerCell: UICollectionViewCell {
    
    enum Layout {
        static let avatarSide: CGFloat = 80.0
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
    
    let positionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 10.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 2
        
        return label
    }()
    
    let placeOfTrainingTitleLabel: UILabel = {
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
    
    let timeOfTrainingTitleLabel: UILabel = {
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
            .top(16.0)
            .left(16.0)
            .size(Layout.avatarSide)
        
        imageViewBackgroundView.frame = imageView.frame
        gradientLayer?.frame = imageViewBackgroundView.bounds
        
        nameLabel.pin
            .after(of: imageView).marginLeft(8.0)
            .top(26.0)
            .right(16.0)
            .sizeToFit(.widthFlexible)
        
        positionLabel.pin
            .after(of: imageView).marginLeft(8.0)
            .below(of: nameLabel).marginTop(4.0)
            .right(16.0)
            .sizeToFit(.widthFlexible)
        
        var topEdge: VerticalEdge = imageView.edge.bottom
        
        if !placeOfTrainingTitleLabel.isHidden {
            placeOfTrainingTitleLabel.pin
                .top(to: topEdge).marginTop(12.0)
                .left(16.0)
                .right(16.0)
                .sizeToFit(.widthFlexible)
            
            placeOfTrainingLabel.pin
                .below(of: placeOfTrainingTitleLabel).marginTop(4.0)
                .left(16.0)
                .right(16.0)
                .sizeToFit(.widthFlexible)
            
            topEdge = placeOfTrainingLabel.edge.bottom
        }
        
        if !timeOfTrainingTitleLabel.isHidden {
            timeOfTrainingTitleLabel.pin
                .top(to: topEdge).marginTop(12.0)
                .left(16.0)
                .right(16.0)
                .sizeToFit(.widthFlexible)
            
            timeOfTrainingLabel.pin
                .below(of: timeOfTrainingTitleLabel).marginTop(4.0)
                .left(16.0)
                .right(16.0)
                .sizeToFit(.widthFlexible)
            
            topEdge = timeOfTrainingLabel.edge.bottom
        }
        
        phoneTitleLabel.pin
            .top(to: topEdge).marginTop(12.0)
            .left(16.0)
            .right(16.0)
            .sizeToFit(.widthFlexible)
        
        phoneLabel.pin
            .below(of: phoneTitleLabel).marginTop(8.0)
            .left(16.0)
            .right(16.0)
            .sizeToFit(.widthFlexible)
        
        topEdge = phoneLabel.edge.bottom
        
        callButton.pin
            .top(to: topEdge).marginTop(12.0)
            .left(16.0)
            .right(16.0)
            .height(38.0)
        
        contentView.pin.height(callButton.frame.maxY + 16.0)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        
        return contentView.frame.size
    }
    
}
