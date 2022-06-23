import UIKit
import SnapKit

class ProfileContentView: RootView {
    
    private let headerView: UIView = {
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
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    let currentCompetitionsView: UserCompetitionsView = {
        let view = UserCompetitionsView()
        view.titleLabel.text = "Текущие соревнования:"
        view.isHidden = true
        
        return view
    }()
    
    let closedCompetitionsView: UserCompetitionsView = {
        let view = UserCompetitionsView()
        view.titleLabel.text = "Завершившиеся соревнования:"
        view.isHidden = true
        
        return view
    }()
    
    private lazy var userCompetitionsStack = UIStackView(views: [
        currentCompetitionsView,
        closedCompetitionsView
    ], spacing: 16.0, distribution: .fill)
    
    let noCompetitionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Пока вы не приняли участие\nв соревнованиях"
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        label.isHidden = true
        
        return label
    }()
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(headerView)
        addSubview(noCompetitionsLabel)
        addSubview(userCompetitionsStack)
        
        headerView.addSubview(imageViewBackgroundView)
        headerView.addSubview(avatarImageView)
        headerView.addSubview(nameLabel)
        headerView.addSubview(idLabel)
        headerView.addSubview(bioLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        imageViewBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(avatarImageView.snp.edges)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(120.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
        noCompetitionsLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.lessThanOrEqualToSuperview().offset(-20.0)
        }
        
        userCompetitionsStack.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.0)
        }
    }
    
}
