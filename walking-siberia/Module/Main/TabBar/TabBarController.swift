import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    private func configure() {
        let unselectedColor = UIColor(hex: 0xCCD2E3)
        let selectedColor = R.color.activeElements() ?? .blue
        let unselectedAttributes: [NSAttributedString.Key: Any] = [.font: R.font.geometriaRegular(size: 10.0) ?? .systemFont(ofSize: 10.0),
                                                                   .foregroundColor: unselectedColor]
        let selectedAttributes: [NSAttributedString.Key: Any] = [.font: R.font.geometriaRegular(size: 10.0) ?? .systemFont(ofSize: 10.0),
                                                                 .foregroundColor: selectedColor]
        
        let routesViewController = RoutesViewController()
        routesViewController.tabBarItem.title = "Маршруты"
        routesViewController.tabBarItem.image = R.image.tabRoutes()?.withTintColor(unselectedColor)
        routesViewController.tabBarItem.selectedImage = R.image.tabRoutes()?.withTintColor(selectedColor)
        
        let currentCompetitionViewController = CompetitionViewController(type: .current)
        let endedCompetitionViewController = CompetitionViewController(type: .ended)
        let pagerViewController = PagerViewController(initialViewControllers: [currentCompetitionViewController, endedCompetitionViewController])
        pagerViewController.title = "Соревнования"
        pagerViewController.tabBarItem.image = R.image.tabCompetition()?.withTintColor(unselectedColor)
        pagerViewController.tabBarItem.selectedImage = R.image.tabCompetition()?.withTintColor(selectedColor)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem.title = "Профиль"
        profileViewController.tabBarItem.image = R.image.tabProfile()?.withTintColor(unselectedColor)
        profileViewController.tabBarItem.selectedImage = R.image.tabProfile()?.withTintColor(selectedColor)
        
        viewControllers = [SwipeNavigationController(rootViewController: routesViewController),
                           SwipeNavigationController(rootViewController: pagerViewController),
                           SwipeNavigationController(rootViewController: profileViewController)]
        
        viewControllers?.forEach({ viewController in
            viewController.tabBarItem.setTitleTextAttributes(unselectedAttributes, for: .normal)
            viewController.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        })
        
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
    }
    
}
