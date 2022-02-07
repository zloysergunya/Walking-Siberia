import UIKit

class LaunchService {
    
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
//        setWindowRoot(viewController: RegisterUserInputViewController())
    }
    
    private func openMain() {
//        setWindowRoot(viewController: TabBarController())
    }
    
    func selectViewController() {
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
    
}
