import UIKit
import IGListKit

protocol FindFriendsViewControllerDelegate: AnyObject {
    func findFriendsViewController(didSelect users: [User])
}

class FindFriendsViewController: ViewController<FindFriendsView> {
    
    weak var delegate: FindFriendsViewControllerDelegate?
    
    private let availableCount: Int
    private var currentParticipants: [User]
    private let provider = FindFriendsProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var loadingState: LoadingState = .none
    private var objects: [FindFriendsSectionModel] = []
    private var query: String?
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    init(availableCount: Int, currentParticipants: [User]) {
        self.availableCount = availableCount
        self.currentParticipants = currentParticipants
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Друзья"
        
        mainView.searchBar.delegate = self
        
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        load(flush: true)
        checkContactsAccess()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.findFriendsViewController(didSelect: currentParticipants)
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
    
    func load(flush: Bool) {
        if let query = query {
            // TODO: add searh
        } else {
            loadFriends(flush: flush)
        }
    }
    
    private func loadFriends(flush: Bool) {
        guard let type = UserSettings.user?.type else {
            close()
            
            return
        }
        provider.loadFriends(filter: "\(type)") { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let users):
                if flush {
                    self.objects.removeAll()
                }
                
                self.objects = users.map { user in
                    let isJoined = self.currentParticipants.contains(where: { $0.userId == user.userId })
                    
                    return FindFriendsSectionModel(user: user, isJoined: isJoined)
                }
                
                self.loadingState = .loaded
                self.adapter.performUpdates(animated: true)
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    private func close() {
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
        return EmptyView()
    }

}

// MARK: - UISearchBarDelegate
extension FindFriendsViewController: UISearchBarDelegate {
    
    func FindFriendsViewController(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}


// MARK: - ListAdapterDataSource
extension FindFriendsViewController: FindFriendsSectionControllerDelegate {
    
    func findFriendsSectionController(didSelect user: User) {
        
    }
    
    func findFriendsSectionController(didSelectAction button: UIButton, user: User) {
        UIImpactFeedbackGenerator().impactOccurred(intensity: 0.7)
        if let index = currentParticipants.firstIndex(where: { $0.userId == user.userId }) {
            currentParticipants.remove(at: index)
        } else {
            currentParticipants.append(user)
        }
        
        button.isSelected.toggle()
    }
    
    func findFriendsSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= objects.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadFriends(flush: false)
        }
    }
    
}