import UIKit
import IGListKit

class ProfileViewController: ViewController<ProfileView> {
    
    private let provider = ProfileProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    
    private var achievements: [Achievement] = []
    private var competitions: [Competition] = []
    private var team: Team? {
        didSet {
            updateTeam(team: team)
        }
    }
    
    private var contentView: ProfileContentView! {
        return mainView.contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.statsButton.addTarget(self, action: #selector(openUserStatistic), for: .touchUpInside)
        mainView.settingsButton.addTarget(self, action: #selector(openProfileEdit), for: .touchUpInside)
        
        contentView.teamView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTeam)))
        contentView.createTeamView.actionButton.addTarget(self, action: #selector(createTeam), for: .touchUpInside)
        
        adapter.collectionView = contentView.achievementsView.collectionView
        adapter.dataSource = self
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        load()
    }
    
    private func load() {
        loadProfile()
        loadCompetitions()
        loadUserTeam()
        loadAchievements()
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
    
    private func loadUserTeam() {
        provider.loadUserTeam { [weak self] result in
            switch result {
            case .success(let team):
                self?.team = team
                self?.updateTeam(team: team)
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func loadAchievements() {
        provider.loadAchievements { [weak self] result in
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
    
    private func configure() {
        guard let user = UserSettings.user else {
            return
        }
        
        if let url = user.profile.avatar {
            ImageLoader.setImage(url: url, imgView: contentView.headerView.avatarImageView)
        } else {
            let side = 120.0
            let fullName = "\(user.profile.firstName) \(user.profile.lastName)"
            let textAttributes: [NSAttributedString.Key: Any] = [.font: R.font.geometriaMedium(size: 42.0)!, .foregroundColor: UIColor.white]
            contentView.headerView.avatarImageView.image = UIImage.createWithBgColorFromText(text: fullName.getInitials(),
                                                                                           color: .clear,
                                                                                           circular: true,
                                                                                           textAttributes: textAttributes,
                                                                                           side: side)
            let gradientLayer = GradientHelper.shared.layer(userId: user.userId)
            gradientLayer?.frame = CGRect(side: side)
            contentView.headerView.gradientLayer = gradientLayer
        }
        
        let age = calculateAge(birthday: user.profile.birthDate ?? "")
        contentView.headerView.nameLabel.text = "\(user.profile.firstName) \(user.profile.lastName), \(age ?? 0)"
        let userCategory: UserCategory? = .init(rawValue: user.type)
        contentView.headerView.idLabel.text = "\(userCategory?.categoryName ?? "Нет данных о категории"), id: \(user.userId)"
        contentView.headerView.bioLabel.text = user.profile.aboutMe
    }
    
    private func updateTeam(team: Team?) {
        let hasTeam = team != nil
        contentView.teamView.isHidden = !hasTeam
        contentView.createTeamView.isHidden = hasTeam
        
        if let team {
            contentView.teamView.nameLabel.text = team.name
            
            let side = 48.0
            contentView.teamView.avatarImageView.image = UIImage.createWithBgColorFromText(
                text: "\(team.userCount)",
                color: .clear,
                circular: true,
                side: side
            )
            
            let gradientLayer = GradientHelper.shared.layer(color: .linearBlueLight)
            gradientLayer?.frame = CGRect(side: side)
            contentView.teamView.gradientLayer = gradientLayer
        }
    }
    
    private func updateCompetitions() {
//        mainView.contentView.noCompetitionsLabel.isHidden = !competitions.isEmpty
//        mainView.contentView.currentCompetitionsView.rootStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
//        mainView.contentView.closedCompetitionsView.rootStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
//        
//        competitions.enumerated().forEach { competition in
//            let view = CompetitionView()
//            view.tag = competition.offset
//            view.nameLabel.text = competition.element.name
//            view.teamsLabel.text = R.string.localizable.teamsCount(number: competition.element.countTeams, preferredLanguages: ["ru"])
//            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCompetition)))
//            
//            if competition.element.isClosed {
//                mainView.contentView.closedCompetitionsView.rootStack.addArrangedSubview(view)
//            } else {
//                mainView.contentView.currentCompetitionsView.rootStack.addArrangedSubview(view)
//            }
//            
//            mainView.contentView.currentCompetitionsView.isHidden = competitions.filter({ !$0.isClosed }).count == 0
//            mainView.contentView.closedCompetitionsView.isHidden = competitions.filter({ $0.isClosed }).count == 0
//        }
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
    
    @objc private func openTeam() {
        guard let team else { return }
        let viewController = TeamViewController(team: team)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func createTeam() {
        let viewController = TeamEditViewController(type: .create)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ListAdapterDataSource
extension ProfileViewController: ListAdapterDataSource {
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

// MARK: - TeamViewControllerDelegate
extension ProfileViewController: TeamViewControllerDelegate {
    func teamViewController(didUpdate team: Team) {
        self.team = team
    }
    
    func teamViewController(didDelete teamId: Int) {
        guard team?.id == teamId else { return }
        team = nil
    }
}

// MARK: - TeamEditViewControllerDelegate
extension ProfileViewController: TeamEditViewControllerDelegate {
    func teamEditViewController(didUpdate team: Team) {
        self.team = team
    }
}
