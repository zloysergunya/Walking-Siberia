import UIKit
import SnapKit

class RoutePlacesView: RootView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Интересные места"
        label.font = R.font.geometriaBold(size: 16.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.contentInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(collectionView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16.0)
            make.height.equalTo(140.0)
        }
    }
    
}
