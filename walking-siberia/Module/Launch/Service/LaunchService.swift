import UIKit

class LaunchService {
    
    private var notificationTokens: [Any] = []
    
    init() {
        addObservers()
    }

    deinit {
        notificationTokens.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
    
    private func setWindowRoot(viewController: UIViewController) {
        let root = navController(viewController)
        
        UIApplication.shared.delegate?.window??.rootViewController = root
    }
    
    private func navController(_ root: UIViewController) -> UINavigationController {
        let navigationController = SwipeNavigationController(rootViewController: root)
        navigationController.isNavigationBarHidden = true
        
        return navigationController
    }
    
    private func openAuth() {
        setWindowRoot(viewController: OnboardingViewController())
    }
    
    private func openAccountSetup() {
        setWindowRoot(viewController: AccountRegisterPrimaryViewController())
    }
    
    private func openMain() {
//        setWindowRoot(viewController: TabBarController())
    }
    
    func openModule() {
        let authService: AuthService? = ServiceLocator.getService()
        authService?.updateApi()
        
        if authService?.authStatus == .unauthorized {
            openAuth()
        } else if !UserSettings.userReady {
            openAccountSetup()
        } else {
            openMain()
        }
    }
    
    private func addObservers() {
        let notificationNames: [Foundation.Notification.Name] = [
            AuthService.statusChangedNotifiaction
        ]

        for name in notificationNames {
            notificationTokens.append(NotificationCenter.default.addObserver(
                                        forName: name,
                                        object: nil,
                                        queue: .main,
                                        using: { [weak self] in self?.handleNotification($0) }
            ))
        }
    }
    
    private func handleNotification(_ notification: Foundation.Notification) {
        switch notification.name {
        case AuthService.statusChangedNotifiaction:
            openModule()
        default:
            break
        }
    }
    
}
