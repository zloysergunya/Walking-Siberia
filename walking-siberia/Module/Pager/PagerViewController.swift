import UIKit
import Swift_PageMenu

class PagerViewController: PageMenuController {
    
    private let initialViewControllers: [UIViewController]

    init(initialViewControllers: [UIViewController]) {
        self.initialViewControllers = initialViewControllers
        super.init(options: StyledPageMenuOptions(menuItemSize: .fixed(width: UIScreen.main.bounds.width / 2, height: 20.0)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.color.greyBackground()
        navigationController?.navigationBar.titleTextAttributes = [.font: R.font.geometriaMedium(size: 14.0) ?? .systemFont(ofSize: 14.0),
                                                                   .foregroundColor: R.color.mainContent() ?? .black]
        
        dataSource = self
    }
    
}

// MARK: - PageMenuControllerDataSource
extension PagerViewController: PageMenuControllerDataSource {
    
    func viewControllers(forPageMenuController pageMenuController: PageMenuController) -> [UIViewController] {
        return initialViewControllers
    }
    
    func menuTitles(forPageMenuController pageMenuController: PageMenuController) -> [String] {
        return initialViewControllers.compactMap({ $0.title })
    }
    
    func defaultPageIndex(forPageMenuController pageMenuController: PageMenuController) -> Int {
        return 0
    }
    
}
