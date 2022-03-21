import UIKit
import SnapKit

class ArticlesView: RootView {
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.refreshControl = UIRefreshControl()
        
        return view
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(collectionView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}
