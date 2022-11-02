import UIKit

class ProfileViewController: ViewController<ProfileView> {
    
    private let provider = ProfileProvider()
    
    private var competitions: [Competition] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.statsButton.addTarget(self, action: #selector(openUserStatistic), for: .touchUpInside)
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
        guard let userId = UserSettings.user?.userId else {
             return
        }
        
        provider.loadCompetitions(userId: userId) { [weak self] result in
            switch result {
            case .success(let competitions):
                self?.competitions = competitions
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
            
            self?.updateCompetitions()
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
        let userCategory: UserCategory? = .init(rawValue: user.type)
        mainView.contentView.idLabel.text = "\(userCategory?.categoryName ?? "Нет данных о категории"), id: \(user.userId)"
        mainView.contentView.bioLabel.text = user.profile.aboutMe
    }
    
    private func updateCompetitions() {
        mainView.contentView.noCompetitionsLabel.isHidden = !competitions.isEmpty
        mainView.contentView.currentCompetitionsView.rootStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        mainView.contentView.closedCompetitionsView.rootStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        competitions.enumerated().forEach { competition in
            let view = CompetitionView()
            view.tag = competition.offset
            view.nameLabel.text = competition.element.name
            view.teamsLabel.text = R.string.localizable.teamsCount(number: competition.element.countTeams, preferredLanguages: ["ru"])
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCompetition)))
            
            if competition.element.isClosed {
                mainView.contentView.closedCompetitionsView.rootStack.addArrangedSubview(view)
            } else {
                mainView.contentView.currentCompetitionsView.rootStack.addArrangedSubview(view)
            }
            
            mainView.contentView.currentCompetitionsView.isHidden = competitions.filter({ !$0.isClosed }).count == 0
            mainView.contentView.closedCompetitionsView.isHidden = competitions.filter({ $0.isClosed }).count == 0
        }
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
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func openUserStatistic() {
        guard let user = UserSettings.user else {
            return
        }
        
        navigationController?.pushViewController(PagerViewController(type: .statistics(user: user)), animated: true)
    }
    
    @objc private func openCompetition(_ gestureRecognizer: UIGestureRecognizer) {
        guard let index = gestureRecognizer.view?.tag else {
            return
        }
        
        let viewController = PagerViewController(type: .competition(competition: competitions[index]))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
