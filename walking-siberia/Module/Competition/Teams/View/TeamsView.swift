import UIKit
import SnapKit

class TeamsView: RootView {
    
    let searchBar = SearchBar()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 100.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.refreshControl = UIRefreshControl()
        view.backgroundColor = .clear
        
        return view
    }()
    
    let takePartButton: ActiveButton = {
        let button = ActiveButton()
        button.isUserInteractionEnabled = false
        
        return button
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(takePartButton)
        
        takePartButton.addShadow()
        
        super.setup()
    }
    
    override func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.right.equalToSuperview().inset(4.0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8.0)
            make.left.right.bottom.equalToSuperview()
        }
        
        takePartButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.height.equalTo(38.0)
        }
    }
    
}
