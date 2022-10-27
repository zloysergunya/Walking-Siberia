import UIKit
import SnapKit

class FindFriendsCell: UICollectionViewCell {
    
    var gradientLayer: CAGradientLayer? {
        didSet {
            if let gradientLayer = gradientLayer {
                imageViewBackgroundView.layer.addSublayer(gradientLayer)
            }
        }
    }
    
    let imageViewBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24.0
        view.layer.masksToBounds = true
        
        return view
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24.0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let actionButton = AddButton()

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 72.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        
        contentView.layer.cornerRadius = 12.0
        contentView.layer.borderWidth = 0.0
        contentView.layer.borderColor = R.color.graphicBlue()?.cgColor
        
        contentView.addSubview(imageViewBackgroundView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(actionButton)
        
        addShadow()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        imageViewBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(imageView.snp.edges)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(12.0)
            make.size.equalTo(48.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(12.0)
        }
        
        actionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12.0)
        }
        
    }

}
