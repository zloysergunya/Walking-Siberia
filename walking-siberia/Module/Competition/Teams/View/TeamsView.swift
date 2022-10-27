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
    
    let createTeamButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.add72()?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.backgroundColor = R.color.activeElements()
        button.layer.cornerRadius = 28.0
        
        return button
    }()
    
    let takePartButton = ActiveButton()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(createTeamButton)
        addSubview(takePartButton)
        
        createTeamButton.addShadow()
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
        
        createTeamButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(12.0)
            make.size.equalTo(56.0)
        }
        
        takePartButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.height.equalTo(38.0)
        }
        
    }
    
}
