import UIKit
import SwiftLoader

class UIService {
    
    private var notificationTokens: [Any] = []
    
    init() {
        addObservers()
        configureLoader()
    }

    deinit {
        notificationTokens.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
    
    func openModule() {
        let authService: AuthService? = ServiceLocator.getService()
        authService?.updateApi()
        
        if authService?.authStatus == .unauthorized || !UserSettings.userReady {
            openAuth()
        } else {
            openMain()
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
        setWindowRoot(viewController: TabBarController())
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
    
    private func configureLoader() {
        var config = SwiftLoader.Config()
        config.size = 100.0
        config.spinnerLineWidth = 3.0
        config.spinnerColor = R.color.activeElements() ?? .blue
        config.foregroundColor = R.color.mainContent() ?? .black
        config.foregroundAlpha = 0.5
        SwiftLoader.setConfig(config)
    }
    
}
