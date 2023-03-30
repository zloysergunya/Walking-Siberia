import UIKit
import SnapKit

final class ProfileAchievementsView: RootView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Достижения"
        label.font = R.font.geometriaBold(size: 20.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    override func setup() {
        isUserInteractionEnabled = true
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(collectionView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.0)
            make.height.equalTo(120.0)
        }
    }
}
