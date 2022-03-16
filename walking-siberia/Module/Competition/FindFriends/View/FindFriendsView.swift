import UIKit
import SnapKit

class FindFriendsView: RootView {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.font = R.font.geometriaMedium(size: 14.0)
        searchBar.searchTextField.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .black
        searchBar.tintColor = .black
        searchBar.barTintColor = R.color.greyLight()
        
        return searchBar
    }()
    
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
        
        addSubview(searchBar)
        addSubview(collectionView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8.0)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
}
