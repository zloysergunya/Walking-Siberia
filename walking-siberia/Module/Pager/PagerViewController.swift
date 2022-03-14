import UIKit
import Swift_PageMenu

class PagerViewController: PageMenuController {
    
    private let initialViewControllers: [UIViewController]

    init(initialViewControllers: [UIViewController], options: PageMenuOptions) {
        self.initialViewControllers = initialViewControllers
        super.init(options: options)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initialViewControllers.forEach({ $0.viewWillAppear(animated) })
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
