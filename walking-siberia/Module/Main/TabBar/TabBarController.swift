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
                
        let competitionsPagerViewController = PagerViewController(type: .competitions)
        competitionsPagerViewController.tabBarItem.image = R.image.tabCompetition()?.withTintColor(unselectedColor)
        competitionsPagerViewController.tabBarItem.selectedImage = R.image.tabCompetition()?.withTintColor(selectedColor)
        
        let informationPagerViewController = PagerViewController(type: .information)
        informationPagerViewController.tabBarItem.title = "Информация"
        informationPagerViewController.tabBarItem.image = R.image.tabInformation()?.withTintColor(unselectedColor)
        informationPagerViewController.tabBarItem.selectedImage = R.image.tabInformation()?.withTintColor(selectedColor)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem.title = "Профиль"
        profileViewController.tabBarItem.image = R.image.tabProfile()?.withTintColor(unselectedColor)
        profileViewController.tabBarItem.selectedImage = R.image.tabProfile()?.withTintColor(selectedColor)
        
        viewControllers = [SwipeNavigationController(rootViewController: routesViewController),
                           SwipeNavigationController(rootViewController: competitionsPagerViewController),
                           SwipeNavigationController(rootViewController: informationPagerViewController),
                           SwipeNavigationController(rootViewController: profileViewController)]
        
        viewControllers?.forEach({ viewController in
            viewController.tabBarItem.setTitleTextAttributes(unselectedAttributes, for: .normal)
            viewController.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        })
        
        tabBar.tintColor = R.color.activeElements()
        tabBar.unselectedItemTintColor = R.color.greyBlue()
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
    }
    
}
