import UIKit
import IGListKit

class FindFriendsViewController: ViewController<FindFriendsView> {
        
    private let teamId: Int
    private let provider = FindFriendsProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var objects: [FindFriendsSectionModel] = []
    private var query: String = ""
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var loadingState: LoadingState = .none {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }
    
    init(teamId: Int) {
        self.teamId = teamId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navBar.leftButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.searchBar.delegate = self
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        loadFriends(flush: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        checkContactsAccess()
    }
    
    private func checkContactsAccess() {
        guard ContactsService.authorizationStatus != .authorized else {
            return
        }
        
        dialog(title: "Поиск контактов",
               message: "Чтобы добавить своих знакомых, резрешите доступ к контактам",
               accessText: "Настройки",
               cancelText: "Позже",
               onAgree: { [weak self] _ in
            self?.openSettings()
        })
    }
    
    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    private func loadFriends(flush: Bool) {
        guard let isDisabled = UserSettings.user?.isDisabled, loadingState != .loading else {
            close()
            return
        }
        
        loadingState = .loading
        
        provider.loadFriends(isDisabled: isDisabled, search: query) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let users):
                if flush {
                    self.objects.removeAll()
                }
                
                self.objects.append(contentsOf: users.map({ FindFriendsSectionModel(user: $0, inTeam: $0.inTeam ?? false) }))
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
            }
        }
    }
    
    private func toggleUser(userId: Int, inTeam: Bool, completion: @escaping(Bool) -> Void) {
        if inTeam {
            deleteUser(userId: userId, completion: completion)
        } else {
            addUser(userId: userId, completion: completion)
        }
    }
    
    private func addUser(userId: Int, completion: @escaping(Bool) -> Void) {
        provider.addUser(teamId: teamId, userId: userId) { [weak self] result in
            switch result {
            case .success:
                completion(true)
                
            case .failure(let error):
                completion(false)
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func deleteUser(userId: Int, completion: @escaping(Bool) -> Void) {
        provider.deleteUser(teamId: teamId, userId: userId) { [weak self] result in
            switch result {
            case .success:
                completion(true)
                
            case .failure(let error):
                completion(false)
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - ListAdapterDataSource
extension FindFriendsViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = FindFriendsSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: loadingState)
    }

}

// MARK: - UISearchBarDelegate
extension FindFriendsViewController: UISearchBarDelegate {
    
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
            self.loadFriends(flush: true)
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
    }
    
}


// MARK: - ListAdapterDataSource
extension FindFriendsViewController: FindFriendsSectionControllerDelegate {
    
    func findFriendsSectionController(didSelect user: User) {
        navigationController?.pushViewController(UserProfileViewController(userId: user.userId), animated: true)
    }
    
    func findFriendsSectionController(didSelectAction button: UIButton, inTeam: Bool, user: User) {
        Utils.impact()
        toggleUser(userId: user.userId, inTeam: inTeam) { [weak self] success in
            if success {
                button.isSelected.toggle()
                if let index = self?.objects.firstIndex(where: { $0.user.userId == user.userId }) {
                    self?.objects[index].inTeam = button.isSelected
                    self?.adapter.performUpdates(animated: true)
                }
            }
        }
    }
    
    func findFriendsSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= objects.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadFriends(flush: false)
        }
    }
    
}
