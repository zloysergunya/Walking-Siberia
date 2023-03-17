import UIKit
import SnapKit

final class ProfileTeamView: RootView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Команда"
        label.font = R.font.geometriaBold(size: 20.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
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
        view.layer.cornerRadius = 24.0
        view.layer.masksToBounds = true
        
        return view
    }()

    let avatarImageView: UIImageView = {
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
        label.numberOfLines = 2
        
        return label
    }()
    
    private let chevronRightImageView = UIImageView(image: R.image.chevronRight24())
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12.0
        
        return view
    }()
    
    private let containerShadowView: UIView = {
        let view = UIView()
        view.addShadow(shadowRadius: 16)
        
        return view
    }()
    
    override func setup() {
        isUserInteractionEnabled = true
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(containerShadowView)
        
        containerShadowView.addSubview(containerView)
        
        containerView.addSubview(imageViewBackgroundView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(chevronRightImageView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        containerShadowView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().inset(20.0)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageViewBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(avatarImageView.snp.edges)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(12.0)
            make.size.equalTo(48.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12.0)
            make.centerY.equalToSuperview()
            make.right.equalTo(chevronRightImageView.snp.left).offset(-12.0)
        }
        
        chevronRightImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(24.0)
        }
    }
    
}
