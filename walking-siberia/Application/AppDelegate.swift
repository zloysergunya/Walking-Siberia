import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
        
        let keychainService = KeychainService()
        ServiceLocator.shared.add(service: keychainService)
        
        let authService = AuthService(keychainService: keychainService)
        ServiceLocator.shared.add(service: authService)
        
        let loggerService = LoggerService()
        LoggerService.setup()
        ServiceLocator.shared.add(service: loggerService)
        
        let healthService = HealthService()
        ServiceLocator.shared.add(service: healthService)
        
        let launchService = UIService()
        launchService.openModule()
        ServiceLocator.shared.add(service: launchService)
        
        FirebaseApp.configure()
        setupKeyboardManager()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any])-> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    private func setupKeyboardManager() {
        let manager = IQKeyboardManager.shared
        manager.toolbarTintColor = R.color.mainContent()
        manager.toolbarDoneBarButtonItemText = "Скрыть"
        manager.placeholderColor = R.color.mainContent()
        manager.toolbarBarTintColor = R.color.greyBackground()
    }
   
}
