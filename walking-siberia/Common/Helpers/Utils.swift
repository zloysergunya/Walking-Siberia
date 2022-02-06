import UIKit
import CoreMotion
import AVFoundation

class Utils {
    
    static func getRootViewController() -> UIViewController? {
        return appDelegate()?.window?.rootViewController
    }
    
    static func getPresentedViewController() -> UIViewController? {
        return getRootViewController()?.presentedViewController
    }

    static func getRootNavigationController() -> UINavigationController? {
        return Utils.getRootViewController() as? UINavigationController
    }
    
    static func getTopViewController() -> UIViewController? {
        return Utils.getRootNavigationController()?.topViewController
    }
    
    static func appDelegate() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    static func safeArea() -> UIEdgeInsets {
        if let safeArea = appDelegate()?.window?.safeAreaInsets {
            return safeArea
        }
        
        return .zero
    }
    
//    static var app: (version: String, build: String, model: String, os: String, name: String) = {
//        let dictionary = Bundle.main.infoDictionary!
//        let version = dictionary["CFBundleShortVersionString"] as? String ?? "Unknown version"
//        let build = dictionary["CFBundleVersion"] as? String ?? "Unknown build"
//        let model = UIDevice.modelName
//        let os = UIDevice.current.systemVersion
//        let name = dictionary["CFBundleName"] as? String ?? "Unknown name"
//
//        return (version, build, model, os, name)
//    }()
    
}
