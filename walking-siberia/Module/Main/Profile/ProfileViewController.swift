import UIKit

class ProfileViewController: ViewController<ProfileView> {
    
    private let provider = ProfileProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.settingsButton.addTarget(self, action: #selector(openProfileEdit), for: .touchUpInside)
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        loadProfile()
        loadCompetitions()
    }
    
    private func loadProfile() {
        provider.loadProfile { [weak self] result in
            switch result {
            case .success(let response):
                UserSettings.user = response
                self?.configure()
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func loadCompetitions() {
        provider.loadCompetitions { [weak self] result in
            switch result {
            case .success(let response):
                self?.updateCompetitions(for: response)
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func configure() {
        guard let user = UserSettings.user else {
            return
        }
        
        if let url = user.profile.avatar {
            ImageLoader.setImage(url: url, imgView: mainView.contentView.avatarImageView)
        } else {
            let side = 120.0
            let fullName = "\(user.profile.firstName) \(user.profile.lastName)"
            let textAttributes: [NSAttributedString.Key: Any] = [.font: R.font.geometriaMedium(size: 42.0)!, .foregroundColor: UIColor.white]
            mainView.contentView.avatarImageView.image = UIImage.createWithBgColorFromText(text: fullName.getInitials(),
                                                                                           color: .clear,
                                                                                           circular: true,
                                                                                           textAttributes: textAttributes,
                                                                                           side: side)
            let gradientLayer = GradientHelper.shared.layer(userId: user.userId)
            gradientLayer?.frame = CGRect(side: side)
            mainView.contentView.gradientLayer = gradientLayer
        }
        
        let age = calculateAge(birthday: user.profile.birthDate ?? "")
        mainView.contentView.nameLabel.text = "\(user.profile.firstName) \(user.profile.lastName), \(age ?? 0)"
        mainView.contentView.idLabel.text = "id: \(user.userId)"
        mainView.contentView.bioLabel.text = user.profile.aboutMe
    }
    
    private func updateCompetitions(for competitions: [Competition]) {
        
    }
    
    private func calculateAge(birthday: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        guard let birthdayDate = dateFormatter.date(from: birthday) else {
            return nil
        }
        
        let age = Calendar.current.dateComponents([.year], from: birthdayDate, to: Date())
        return age.year
    }
    
    @objc private func openProfileEdit() {
        let viewController = ProfileEditViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
