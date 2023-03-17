import UIKit
import SnapKit

class ProfileContentView: RootView {
    
    let headerView = ProfileHeaderView()
    
    let createTeamView: ProfileCreateTeamView = {
        let view = ProfileCreateTeamView()
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
    
    private lazy var rootStack = UIStackView(views: [
        headerView,
        createTeamView,
        teamView,
        achievementsView
    ], spacing: 8.0, distribution: .fill)
    
//    let currentCompetitionsView: UserCompetitionsView = {
//        let view = UserCompetitionsView()
//        view.titleLabel.text = "Текущие соревнования:"
//        view.isHidden = true
//
//        return view
//    }()
//
//    let closedCompetitionsView: UserCompetitionsView = {
//        let view = UserCompetitionsView()
//        view.titleLabel.text = "Завершившиеся соревнования:"
//        view.isHidden = true
//
//        return view
//    }()
//
//    private lazy var userCompetitionsStack = UIStackView(views: [
//        currentCompetitionsView,
//        closedCompetitionsView
//    ], spacing: 16.0, distribution: .fill)
//
//    let noCompetitionsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Пока вы не приняли участие\nв соревнованиях"
//        label.font = R.font.geometriaMedium(size: 14.0)
//        label.textColor = R.color.mainContent()
//        label.numberOfLines = 0
//        label.isHidden = true
//
//        return label
//    }()
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(rootStack)
        
        super.setup()
    }
    
    override func setupConstraints() {
        rootStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
