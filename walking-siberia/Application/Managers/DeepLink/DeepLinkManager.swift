import UIKit
import SwiftLoader
import AVFoundation
import AVKit

class DeepLinkManager {
    
    private let notificationParser: DeepLinkNotificationParser
    private let universalParser: DeepLinkUniversalParser
    private let provider = DeepLinkProvider()
    
    private var deeplink: DeepLink?
    private var rootViewController: UIViewController? {
        return UIApplication.shared.delegate?.window??.rootViewController
    }
    private var navigationController: UINavigationController? {
        return UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController
    }
    
    init(
        notificationParser: DeepLinkNotificationParser = DeepLinkNotificationParser(),
        universalParser: DeepLinkUniversalParser = DeepLinkUniversalParser()
    ) {
        self.notificationParser = notificationParser
        self.universalParser = universalParser
    }
    
    @discardableResult
    func handle(_ userInfo: [AnyHashable: Any]) -> Bool {
        guard let deeplink = notificationParser.parse(userInfo) else {
            return false
        }
        
        self.deeplink = deeplink
        routeIfNeeded()
        
        return true
    }
    
    @discardableResult
    func handle(_ url: URL) -> Bool {
        guard let deeplink = universalParser.parse(url) else {
            return false
        }
        
        self.deeplink = deeplink
        routeIfNeeded()
        
        return true
    }
    
    @discardableResult
    func handle(_ userActivity: NSUserActivity) -> Bool {
        guard let deeplink = notificationParser.parse(userActivity) else { return false }
        
        self.deeplink = deeplink
        routeIfNeeded()
        
        return true
    }
    
    func getDeepLink() -> DeepLink? {
        return deeplink
    }
    
    func removeDeepLink() {
        deeplink = nil
    }
    
    func routeIfNeeded() {
        guard let deeplink = getDeepLink() else {
            return
        }
        
        removeDeepLink()
        
        guard KeychainService().token != nil else {
            return
        }
        
        switch deeplink {
        case .article(let id): openArticle(id: id)
        case .competition(let id): openCompetition(id: id)
        case .friend(let id): openFriend(id: id)
        case .reward(let id): openCompetition(id: id)
        case .route(let id): openRoute(id: id)
        case .video(let id): openVideo(id: id)
        }
    }
    
    private func openArticle(id: Int) {
        SwiftLoader.show(animated: true)
        provider.loadArticle(id: id) { [weak self] result in
            SwiftLoader.hide()
            
            switch result {
            case .success(let article):
                let viewController = ArticleViewController(article: article)
                self?.openViewController(viewController)
                
            case .failure(let error):
                SwiftLoader.show(title: error.message(), animated: true)
            }
        }
    }
    
    private func openCompetition(id: Int) {
        SwiftLoader.show(animated: true)
        provider.loadСompetition(id: id) { [weak self] result in
            SwiftLoader.hide()
            
            switch result {
            case .success(let competition):
                let viewController = PagerViewController(type: .competition(competition: competition))
                self?.openViewController(viewController)
                
            case .failure(let error):
                SwiftLoader.show(title: error.message(), animated: true)
            }
        }
    }
    
    private func openFriend(id: Int) {
        let viewController = UserProfileViewController(userId: id)
        openViewController(viewController)
    }

    private func openRoute(id: Int) {
        SwiftLoader.show(animated: true)
        provider.loadRoute(id: id) { [weak self] result in
            SwiftLoader.hide()
            
            switch result {
            case .success(let route):
                let viewController = RouteInfoViewController(route: route)
                self?.openViewController(viewController)
                
            case .failure(let error):
                SwiftLoader.show(title: error.message(), animated: true)
            }
        }
    }
    
    private func openVideo(id: Int) {
        SwiftLoader.show(animated: true)
        provider.loadVideo(id: id) { [weak self] result in
            SwiftLoader.hide()
            
            switch result {
            case .success(let video):
                guard let url = URL(string: video.file),
                      let rootViewController = self?.rootViewController
                else { return }
                
                let player = AVPlayer(url: url)
                let viewController = AVPlayerViewController()
                viewController.player = player
                
                rootViewController.present(viewController, animated: true) {
                    viewController.player?.play()
                }
                
            case .failure(let error):
                SwiftLoader.show(title: error.message(), animated: true)
            }
        }
    }
    
    private func openViewController(_ viewController: UIViewController) {
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: true)
        }  else if let rootViewController = rootViewController {
            rootViewController.present(viewController, animated: true)
        }
    }
    
}
