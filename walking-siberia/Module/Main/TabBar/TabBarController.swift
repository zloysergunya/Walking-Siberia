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
        routesViewController.tabBarItem.setTitleTextAttributes(unselectedAttributes, for: .normal)
        routesViewController.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        routesViewController.tabBarItem.title = "Маршруты"
        routesViewController.tabBarItem.image = R.image.tabRoutes()?.withTintColor(unselectedColor)
        routesViewController.tabBarItem.selectedImage = R.image.tabRoutes()?.withTintColor(selectedColor)
        
        viewControllers = [SwipeNavigationController(rootViewController: routesViewController)]
    }
    
}
