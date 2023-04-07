import UIKit
import IGListKit

class UserProfileViewController: ViewController<UserProfileView> {
    
    private let userId: Int
    private let provider = UserProfileProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var achievements: [Achievement] = []
    private var currentUser: User?
    private var loadingState: LoadingState = .none
    private var competitions: [Competition] = []
    private var team: Team?
    
    private var contentView: UserProfileContentView! {
        return mainView.contentView
    }
    
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
        contentView.statsButton.addTarget(self, action: #selector(openUserStatistic), for: .touchUpInside)
        contentView.addAsFriendButton.addTarget(self, action: #selector(toggleIsFriend), for: .touchUpInside)
        contentView.telegramButton.addTarget(self, action: #selector(openSocialLink), for: .touchUpInside)
        contentView.instagramButton.addTarget(self, action: #selector(openSocialLink), for: .touchUpInside)
        contentView.vkButton.addTarget(self, action: #selector(openSocialLink), for: .touchUpInside)
        contentView.okButton.addTarget(self, action: #selector(openSocialLink), for: .touchUpInside)
        contentView.teamView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTeam)))
        
        adapter.collectionView = contentView.achievementsView.collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        load()
    }
    
    private func load() {
        loadUser()
        loadUserTeam()
        loadCompetitions()
        loadAchievements()
    }
    
    private func configure(user: User) {
        if let url = user.profile.avatar {
            ImageLoader.setImage(url: url, imgView: contentView.avatarImageView)
        } else {
            let side = 120.0
            let fullName = "\(user.profile.firstName) \(user.profile.lastName)"
            let textAttributes: [NSAttributedString.Key: Any] = [.font: R.font.geometriaMedium(size: 42.0)!, .foregroundColor: UIColor.white]
            contentView.avatarImageView.image = UIImage.createWithBgColorFromText(
                text: fullName.getInitials(),
                color: .clear,
                circular: true,
                textAttributes: textAttributes,
                side: side
            )
            let gradientLayer = GradientHelper.shared.layer(userId: user.userId)
            gradientLayer?.frame = CGRect(side: side)
            contentView.gradientLayer = gradientLayer
        }
        
        let age = calculateAge(birthday: user.profile.birthDate ?? "")
        let userCategory: UserCategory? = .init(rawValue: user.type)
        contentView.nameLabel.text = "\(user.profile.firstName) \(user.profile.lastName), \(age ?? 0)"
        contentView.categoryLabel.text = "\(userCategory?.categoryName ?? "Нет данных о категории"), id: \(user.userId)"
        contentView.bioLabel.text = user.profile.aboutMe
        
        contentView.addAsFriendButton.isSelected = user.isFriend == true
        contentView.addAsFriendButton.isHidden = user.userId == UserSettings.user?.userId
        
        if let urlString = user.profile.telegram, let url = URL(string: urlString) {
            contentView.telegramButton.url = url
            contentView.telegramButton.isHidden = false
        }
        if let urlString = user.profile.vkontakte, let url = URL(string: urlString) {
            contentView.vkButton.url = url
            contentView.vkButton.isHidden = false
        }
        if let urlString = user.profile.odnoklassniki, let url = URL(string: urlString) {
            contentView.okButton.url = url
            contentView.okButton.isHidden = false
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
                self.updateTeam(team: self.team)
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
            }
        }
    }
    
    private func loadUserTeam() {
        provider.loadUserTeam(id: userId) { [weak self] result in
            switch result {
            case .success(let team):
                self?.team = team
                self?.updateTeam(team: team)
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
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
    
    private func loadAchievements() {
        provider.loadAchievements(id: userId) { [weak self] result in
            switch result {
            case .success(let achievements):
                self?.achievements = achievements
                self?.contentView.achievementsView.isHidden = achievements.count == 0
                self?.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func updateCompetitions() {
        contentView.noCompetitionsLabel.isHidden = !competitions.isEmpty
        contentView.currentCompetitionsView.rootStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        contentView.closedCompetitionsView.rootStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        competitions.enumerated().forEach { competition in
            let view = CompetitionView()
            view.tag = competition.offset
            view.nameLabel.text = competition.element.name
            view.teamLabel.text = competition.element.teamName ?? "Нет имени"
            let place = competition.element.place ?? 0
            view.placeLabel.text = "Место: \(place)/\(competition.element.countTeams)"
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCompetition)))
            
            if competition.element.isClosed {
                contentView.closedCompetitionsView.rootStack.addArrangedSubview(view)
            } else {
                contentView.currentCompetitionsView.rootStack.addArrangedSubview(view)
            }
            
            contentView.currentCompetitionsView.isHidden = competitions.filter({ !$0.isClosed }).count == 0
            contentView.closedCompetitionsView.isHidden = competitions.filter({ $0.isClosed }).count == 0
        }
    }
    
    private func updateTeam(team: Team?) {
        let hasTeam = team != nil
        let isDisabled = currentUser?.isDisabled ?? false
        contentView.teamView.isHidden = !hasTeam || isDisabled
        contentView.noTeamView.isHidden = hasTeam || isDisabled
        
        if let team {
            contentView.teamView.nameLabel.text = team.name
            
            let side = 48.0
            contentView.teamView.avatarImageView.image = UIImage.createWithBgColorFromText(
                text: "\(team.userCount ?? 0)",
                color: .clear,
                circular: true,
                side: side
            )
            
            let gradientLayer = GradientHelper.shared.layer(color: .linearBlueLight)
            gradientLayer?.frame = CGRect(side: side)
            contentView.teamView.gradientLayer = gradientLayer
        }
    }
    
    private func addAsFriend(completion: @escaping(Bool) -> Void) {
        contentView.addAsFriendButton.isLoading = true
        provider.addFriend(id: userId) { [weak self] result in
            self?.handleToggleIsFriendResult(result, completion: completion)
        }
    }
    
    private func removeFromFriends(completion: @escaping(Bool) -> Void) {
        contentView.addAsFriendButton.isLoading = true
        provider.removeFriend(id: userId) { [weak self] result in
            self?.handleToggleIsFriendResult(result, completion: completion)
        }
    }
    
    private func handleToggleIsFriendResult(_ result: Result<SuccessResponse<EmptyData>, ModelError>, completion: @escaping(Bool) -> Void) {
        contentView.addAsFriendButton.isLoading = false
        
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
    
    @objc private func openTeam() {
        guard let team else { return }
        let viewController = TeamViewController(team: team, competition: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - ListAdapterDataSource
extension UserProfileViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return achievements
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ProfileAchievementsSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
