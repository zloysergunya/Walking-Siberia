import UIKit
import IGListKit

class ArticlesViewController: ViewController<ArticlesView> {
    
    private let provider = ArticlesProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var objects: [ArticleSectionModel] = []
    private var loadingState: LoadingState = .none {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        
        title = "Статьи"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadArticles(flush: true)
    }
    
    private func loadArticles(flush: Bool) {
        guard loadingState != .loading else {
            return
        }
        
        loadingState = .loading
        
        if flush {
            provider.page = 1
        }
        
        provider.loadArticles { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let articles):
                if flush {
                    self.objects.removeAll()
                }
                
                self.objects.append(contentsOf: articles.map({ ArticleSectionModel(article: $0) }))
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
            }
        }
    }
    
    private func addViewTo(articleId: Int) {
        provider.addViewTo(articleId: articleId) { [weak self] result in
            switch result {
            case .success: break
            case .failure(let error): self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func pullToRefresh() {
        loadArticles(flush: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension ArticlesViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = ArticlesSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: loadingState)
    }

}

// MARK: - ArticlesSectionControllerDelegate
extension ArticlesViewController: ArticlesSectionControllerDelegate {
    
    func articlesSectionController(didSelect article: Article) {
        addViewTo(articleId: article.id)
        navigationController?.pushViewController(ArticleViewController(article: article), animated: true)
    }
    
    func articlesSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= objects.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadArticles(flush: false)
        }
    }
    
}
