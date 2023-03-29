import UIKit
import SnapKit

class UserProfileContentView: RootView {
    
    private let containerView: UIView = {
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
    
    let categoryLabel: UILabel = {
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
        
        return label
    }()
    
    let addAsFriendButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Добавить в друзья", for: .normal)
        button.setTitle("Удалить из друзей", for: .selected)
        
        return button
    }()
    
    let statsButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.chart30(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    let telegramButton = SocialButton(type: .telegram)
    let instagramButton = SocialButton(type: .instagram)
    let vkButton = SocialButton(type: .vk)
    let okButton = SocialButton(type: .ok)
    
    private lazy var buttonsStackView = UIStackView(views: [
        addAsFriendButton,
        statsButton
    ], axis: .horizontal, spacing: 8.0, distribution: .fillProportionally)
    
    private lazy var socialLinksStackView = UIStackView(views: [
        telegramButton,
        instagramButton,
        vkButton,
        okButton
    ], axis: .horizontal, spacing: 8.0)
    
    let noTeamView: UserProfileNoTeamView = {
        let view = UserProfileNoTeamView()
        view.isHidden = true
        
        return view
    }()
    
    let teamView: ProfileTeamView = {
        let view = ProfileTeamView()
        view.isHidden = true
        
        return view
    }()
    
    let achievementsView: ProfileAchievementsView = {
        let view = ProfileAchievementsView()
        view.isHidden = true
        
        return view
    }()
    
    let currentCompetitionsView: UserCompetitionsView = {
        let view = UserCompetitionsView()
        view.titleLabel.text = "Текущие соревнования"
        view.isHidden = true

        return view
    }()

    let closedCompetitionsView: UserCompetitionsView = {
        let view = UserCompetitionsView()
        view.titleLabel.text = "Завершившиеся соревнования"
        view.isHidden = true

        return view
    }()
    
    let noCompetitionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Этот пользователь еще не принимал участия в соревнованиях"
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true

        return label
    }()
    
    private lazy var rootStack = UIStackView(views: [
        containerView,
        noTeamView,
        teamView,
        currentCompetitionsView,
        achievementsView,
        closedCompetitionsView,
        noCompetitionsLabel
    ], spacing: 8.0, distribution: .fill)
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(rootStack)
        
        containerView.addSubview(imageViewBackgroundView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(bioLabel)
        containerView.addSubview(buttonsStackView)
        containerView.addSubview(socialLinksStackView)

        super.setup()
    }
    
    override func setupConstraints() {
        rootStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageViewBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(avatarImageView.snp.edges)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(56.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(120.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(12.0)
            make.centerX.equalToSuperview()
        }
        
        addAsFriendButton.snp.makeConstraints { make in
            make.height.equalTo(30.0)
            make.width.equalTo(172.0)
        }
        
        statsButton.snp.makeConstraints { make in
            make.width.equalTo(35.0)
            make.height.equalTo(30.0)
        }
        
        socialLinksStackView.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(12.0)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
        telegramButton.snp.makeConstraints { make in
            make.width.equalTo(40.0)
            make.height.equalTo(36.0)
        }
    }
    
}
