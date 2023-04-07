import UIKit
import SnapKit

class TrainersView: RootView {

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 16.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.refreshControl = UIRefreshControl()
        
        return view
    }()
    
    let dropDownMenu = CityDropDownView(type: .trainers)

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(collectionView)
        addSubview(dropDownMenu)
        
        super.setup()
    }
    
    override func setupConstraints() {
        dropDownMenu.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60.0)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
}
