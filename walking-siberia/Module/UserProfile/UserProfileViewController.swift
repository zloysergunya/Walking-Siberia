import UIKit

class UserProfileViewController: ViewController<UserProfileView> {
    
    private let userId: Int
    private let provider = UserProfileProvider()
    
    private var currentUser: User?
    private var loadingState: LoadingState = .none
    private var competitions: [Competition] = []
    
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navBar.leftButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.contentView.statsButton.addTarget(self, action: #selector(openUserStatistic), for: .touchUpInside)
        mainView.contentView.addAsFriendButton.addTarget(self, action: #selector(toggleIsFriend), for: .touchUpInside)
        mainView.contentView.telegramButton.addTarget(self, action: #selector(openSocialLink), for: .touchUpInside)
        mainView.contentView.instagramButton.addTarget(self, action: #selector(openSocialLink), for: .touchUpInside)
        mainView.contentView.vkButton.addTarget(self, action: #selector(openSocialLink), for: .touchUpInside)
        mainView.contentView.okButton.addTarget(self, action: #selector(openSocialLink), for: .touchUpInside)
        
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        load()
    }
    
    private func load() {
        loadUser()
        loadCompetitions()
    }
    
    private func configure(user: User) {
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
        let userCategory: UserCategory? = .init(rawValue: user.type)
        mainView.contentView.nameLabel.text = "\(user.profile.firstName) \(user.profile.lastName), \(age ?? 0)"
        mainView.contentView.categoryLabel.text = "\(userCategory?.categoryName ?? "Нет данных о категории"), id: \(user.userId)"
        mainView.contentView.bioLabel.text = user.profile.aboutMe
        
        mainView.contentView.addAsFriendButton.isSelected = user.isFriend == true
        mainView.contentView.addAsFriendButton.isHidden = user.userId == UserSettings.user?.userId
        
        if let urlString = user.profile.telegram, let url = URL(string: urlString) {
            mainView.contentView.telegramButton.url = url
            mainView.contentView.telegramButton.isHidden = false
        }
//        if let urlString = user.profile.instagram, let url = URL(string: urlString) {
//            mainView.contentView.instagramButton.url = url
//            mainView.contentView.instagramButton.isHidden = false
//        }
        if let urlString = user.profile.vkontakte, let url = URL(string: urlString) {
            mainView.contentView.vkButton.url = url
            mainView.contentView.vkButton.isHidden = false
        }
        if let urlString = user.profile.odnoklassniki, let url = URL(string: urlString) {
            mainView.contentView.okButton.url = url
            mainView.contentView.okButton.isHidden = false
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
    
    private func loadUser() {
        guard loadingState != .loading else { return }
        
        loadingState = .loading
        
        provider.loadUser(id: userId) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let user):
                self.currentUser = user
                if user.userId == UserSettings.user?.userId {
                    UserSettings.user = user
                }
                self.configure(user: user)
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
            }
        }
    }
    
    private func loadCompetitions() {
        provider.loadCompetitions(userId: userId) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let competitions):
                self.competitions = competitions
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
            
            self.updateCompetitions()
        }
    }
    
    private func updateCompetitions() {
        mainView.contentView.noCompetitionsLabel.isHidden = !competitions.isEmpty
        mainView.contentView.currentCompetitionsView.rootStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        mainView.contentView.closedCompetitionsView.rootStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        competitions.enumerated().forEach { competition in
            let view = CompetitionView()
            view.tag = competition.offset
            view.nameLabel.text = competition.element.name
            view.teamLabel.text = competition.element.statusLabel
            view.placeLabel.text = "Место: 1/\(competition.element.countTeams)"
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
    
    private func addAsFriend(completion: @escaping(Bool) -> Void) {
        mainView.contentView.addAsFriendButton.isLoading = true
        provider.addFriend(id: userId) { [weak self] result in
            self?.handleToggleIsFriendResult(result, completion: completion)
        }
    }
    
    private func removeFromFriends(completion: @escaping(Bool) -> Void) {
        mainView.contentView.addAsFriendButton.isLoading = true
        provider.removeFriend(id: userId) { [weak self] result in
            self?.handleToggleIsFriendResult(result, completion: completion)
        }
    }
    
    private func handleToggleIsFriendResult(_ result: Result<SuccessResponse<EmptyData>, ModelError>, completion: @escaping(Bool) -> Void) {
        mainView.contentView.addAsFriendButton.isLoading = false
        
        switch result {
        case .success:
            completion(true)
            
        case .failure(let error):
            showError(text: error.localizedDescription)
            completion(false)
        }
    }
    
    @objc private func toggleIsFriend(_ sender: UIButton) {
        if sender.isSelected {
            removeFromFriends { success in
                if success {
                    sender.isSelected.toggle()
                }
            }
        } else {
            addAsFriend { success in
                if success {
                    sender.isSelected.toggle()
                }
            }
        }
    }
    
    @objc private func openUserStatistic() {
        guard let user = currentUser else { return }
        navigationController?.pushViewController(UserStatisticViewController(user: user), animated: true)
    }
    
    @objc private func openSocialLink(_ sender: SocialButton) {
        guard let url = sender.url else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    @objc private func openCompetition(_ gestureRecognizer: UIGestureRecognizer) {
        guard let index = gestureRecognizer.view?.tag else {
            return
        }
        
        let viewController = PagerViewController(type: .competition(competition: competitions[index]))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
}
