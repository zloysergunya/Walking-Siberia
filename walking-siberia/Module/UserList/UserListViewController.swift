import UIKit
import IGListKit

class UserListViewController: ViewController<UserListView> {
    
    private let isGLobalList: Bool
    private let provider = UserListProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var loadingState: LoadingState = .none
    private var objects: [UserListSectionModel] = []
    private var query: String = ""
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var filter = ""
    private var filterButtons: [UIButton] {
        return [mainView.childrenButton, mainView.studentButton, mainView.adultButton,
                mainView.pensionerButton, mainView.manWithHIAButton]
    }

    init(isGLobalList: Bool) {
        self.isGLobalList = isGLobalList
        super.init(nibName: nil, bundle: nil)
        
        title = isGLobalList ? "Общий рейтинг" : "Друзья"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.searchBar.delegate = self
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        filterButtons.forEach({ $0.addTarget(self, action: #selector(updateFilter), for: .touchUpInside) })
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        load(flush: true)
    }
    
    private func load(flush: Bool) {
        guard loadingState != .loading else {
            return
        }
        
        loadingState = .loading
        
        if flush {
            provider.page = 1
        }
        
        if isGLobalList {
            loadUsers(flush: flush)
        } else {
            loadFriends(flush: flush)
        }
    }
    
    private func loadFriends(flush: Bool) {
        provider.loadFriends(filter: filter, search: query) { [weak self] result in
            self?.handleResult(flush: flush, result: result)
        }
    }
    
    private func loadUsers(flush: Bool) {
        provider.loadUsers(filter: filter, search: query) { [weak self] result in
            self?.handleResult(flush: flush, result: result)
        }
    }
    
    private func handleResult(flush: Bool, result: Result<[User], ModelError>) {
        mainView.collectionView.refreshControl?.endRefreshing()
        
        switch result {
        case .success(let users):
            if flush {
                objects.removeAll()
            }

            objects.append(contentsOf: users.map({ UserListSectionModel(user: $0) }))
            loadingState = .loaded
            
        case .failure(let error):
            showError(text: error.localizedDescription)
            loadingState = .failed(error: error)
        }
        
        adapter.performUpdates(animated: true)
    }
    
    @objc private func pullToRefresh() {
        load(flush: true)
    }
    
    @objc private func updateFilter(_ sender: UIButton) {
        var filter = ""
        filterButtons.forEach({ button in
            if button.tag == sender.tag && button.isSelected {
                button.isSelected = false
            } else {
                button.isSelected = button.tag == sender.tag
                if button.isSelected {
                    filter = "\(sender.tag)"
                }
            }
        })

        self.filter = filter
        load(flush: true)
    }
    
}

// MARK: - UISearchBarDelegate
extension UserListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard query != searchText.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else {
                return
            }
            
            if searchText.isEmpty {
                self.query = ""
            } else {
                self.query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            self.load(flush: true)
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
    }
    
}

// MARK: - ListAdapterDataSource
extension UserListViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = UserListSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: loadingState)
    }
    
}

// MARK: - UserListSectionControllerDelegate
extension UserListViewController: UserListSectionControllerDelegate {
    
    func userListSectionController(didSelect user: User) {
        navigationController?.pushViewController(UserProfileViewController(userId: user.userId), animated: true)
    }
    
    func userListSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= objects.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            load(flush: false)
        }
    }
    
}
