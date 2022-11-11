import UIKit
import SnapKit

class FindFriendsView: RootView {
    
    let navBar: NavBarView = {
        let view = NavBarView()
        view.backgroundColor = R.color.greyBackground()
        let configuration = NavBarConfiguration(title: "Друзья",
                                                subtitle: nil,
                                                leftButtonImage: R.image.chevronLeft24(),
                                                rightButtonImage: nil)
        view.configure(with: configuration)
        
        return view
    }()
    
    let searchBar = SearchBar()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.keyboardDismissMode = .onDrag
        
        return view
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(navBar)
        addSubview(searchBar)
        addSubview(collectionView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        navBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(32.0)
        }
        
        searchBar.searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8.0)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
}
