import UIKit

class ProfileViewController: ViewController<ProfileView> {
    
    private let provider = ProfileProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                if let user = response.data {
                    UserSettings.user = user
                }
                self?.configure()
                
            case .failure(let error):
                error.localizedDescription // todo
            }
        }
    }
    
    private func loadCompetitions() {
        provider.loadCompetitions { [weak self] result in
            switch result {
            case .success(let response):
                self?.updateCompetitions(for: [.init(id: 0, name: "0"), .init(id: 1, name: "1")])
                
            case .failure(let error):
                error.localizedDescription // todo
            }
        }
    }
    
    private func configure() {
        guard let user = UserSettings.user else {
            return
        }
        
        ImageLoader.setImage(url: user.profile.avatar,
                             imgView: mainView.contentView.avatarImageView)
        
        let age = calculateAge(birthday: user.profile.birthDate ?? "")
        mainView.contentView.nameLabel.text = "\(user.profile.firstName) \(user.profile.lastName), \(age ?? 0)"
        mainView.contentView.idLabel.text = "id: \(user.userID)"
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
    
}