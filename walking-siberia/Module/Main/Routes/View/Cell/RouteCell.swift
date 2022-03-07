import UIKit
import SnapKit

class RouteCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.numberOfLines = 2
        
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.heart16(), for: .normal)
        button.setImage(R.image.heartFill16(), for: .selected)
        button.setTitleColor(R.color.mainContent(), for: .normal)
        button.titleLabel?.font = R.font.geometriaRegular(size: 12.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 4.0)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    private let chevronImageView = UIImageView(image: R.image.chevronRight24())
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12.0
        addShadow()
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(chevronImageView)
        contentView.addSubview(likeButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(108.0)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-4.0)
            make.size.equalTo(24.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.left.equalTo(imageView.snp.right).offset(8.0)
            make.right.equalTo(chevronImageView.snp.left).offset(-12.0)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            make.left.equalTo(imageView.snp.right).offset(8.0)
            make.right.equalTo(chevronImageView.snp.left).offset(-12.0)
        }
        
        likeButton.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(8.0)
            make.bottom.equalToSuperview().offset(-8.0)
        }
        
        likeButton.imageView?.snp.makeConstraints { make in
            make.size.equalTo(16.0)
        }
        
    }
    
}
