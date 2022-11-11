import UIKit
import SwiftyBeaver
import Kingfisher

class TabBarController: UITabBarController {
    
    @Autowired
    private var authService: AuthService?

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
        
        // Add dev menu to last tab
        if let view = tabBar.items?.last?.value(forKey: "view") as? UIView {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDeveloperMenu))
            gestureRecognizer.cancelsTouchesInView = false
            gestureRecognizer.delaysTouchesEnded = false
            gestureRecognizer.numberOfTapsRequired = 5
            view.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    @objc private func openDeveloperMenu() {
        let alert = UIAlertController(title: "Version: \(Constants.appVersion)", message: "userId: \(UserSettings.user?.userId ?? -1)", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Switch to \(UserSettings.isDev ? "prod" : "dev")", style: .default, handler: { [weak self] _ in
            UserSettings.isDev.toggle()
            self?.authService?.deauthorize()
        }))
        
        alert.addAction(UIAlertAction(title: "Copy userId", style: .default, handler: { _ in
            UIPasteboard.general.string = String(UserSettings.user?.userId ?? -1)
        }))
        
        alert.addAction(UIAlertAction(title: "Copy token", style: .default, handler: { _ in
            let keychainService: KeychainService? = ServiceLocator.getService()
            UIPasteboard.general.string = keychainService?.token
        }))
        
        alert.addAction(UIAlertAction(title: "Send logs", style: .default, handler: { [weak self] _ in
            guard let logFileURL = FileDestination().logFileURL else {
                return
            }
            
            let viewController = UIActivityViewController(activityItems: [logFileURL], applicationActivities: nil)
            self?.present(viewController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Clear cache", style: .default, handler: { _ in
            ImageCache.default.clearCache()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
}
