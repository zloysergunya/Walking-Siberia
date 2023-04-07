import UIKit
import Swift_PageMenu
import SnapKit

class PagerViewController: PageMenuController {
    
    enum PagerType {
        case competitions
        case competition(competition: Competition)
        case statistics(user: User)
        case information
    }
    
    private let initialViewControllers: [UIViewController]
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.activeElements()?.withAlphaComponent(0.5)
        
        return view
    }()
    
    init(type: PagerType) {
        var viewControllers: [UIViewController] = []
        switch type {
        case .competitions:
            viewControllers.append(CompetitionsViewController(type: .current))
            viewControllers.append(CompetitionsViewController(type: .ended))
            
        case .competition(let competition):
            viewControllers.append(CompetitionInfoViewController(competition: competition))
            viewControllers.append(TeamsViewController(competition: competition, competitionType: .team))
            viewControllers.append(TeamsViewController(competition: competition, competitionType: .single))
            
        case .statistics(let user):
            viewControllers.append(UserStatisticViewController(user: user))
            viewControllers.append(UserListViewController(isGLobalList: false))
            viewControllers.append(UserListViewController(isGLobalList: true))
            
        case .information:
            viewControllers.append(TrainersViewController())
            viewControllers.append(ExpertsViewController())
            viewControllers.append(ArticlesViewController())
            viewControllers.append(VideosViewController())
        }
        
        self.initialViewControllers = viewControllers
        super.init(options: StyledPageMenuOptions(for: viewControllers.count))
        
        switch type {
        case .competitions: title = "Соревнования"
        case .competition: title = "О соревновании"
        case .statistics: title = "Статистика"
        case .information: title = "Скандинавская ходьба"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.color.greyBackground()
        navigationController?.navigationBar.titleTextAttributes = [.font: R.font.geometriaMedium(size: 14.0) ?? .systemFont(ofSize: 14.0),
                                                                   .foregroundColor: R.color.mainContent() ?? .black]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        tabMenuView.addSubview(separator)
        
        dataSource = self
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        initialViewControllers.forEach({ $0.viewWillAppear(animated) })
    }
    
    private func setupConstraints() {
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
}

// MARK: - PageMenuControllerDataSource
extension PagerViewController: PageMenuControllerDataSource {
    
    func viewControllers(forPageMenuController pageMenuController: PageMenuController) -> [UIViewController] {
        return initialViewControllers
    }
    
    func menuTitles(forPageMenuController pageMenuController: PageMenuController) -> [String] {
        return initialViewControllers.compactMap({ $0.title })
    }
    
    func defaultPageIndex(forPageMenuController pageMenuController: PageMenuController) -> Int {
        return 0
    }
    
}
