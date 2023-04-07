import UIKit
import SnapKit

class NotificationsView: RootView {
    
    let navBar: NavBarView = {
        let view = NavBarView()
        view.backgroundColor = R.color.greyBackground()
        let configuration = NavBarConfiguration(title: "Уведомления",
                                                subtitle: nil,
                                                leftButtonImage: R.image.chevronLeft24(),
                                                rightButtonImage: nil)
        view.configure(with: configuration)
        
        return view
    }()

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 100.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.refreshControl = UIRefreshControl()
        
        return view
    }()
    
    let clearAllButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Очистить все", for: .normal)
        
        return button
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(navBar)
        addSubview(collectionView)
        addSubview(clearAllButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        navBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(8.0)
            make.left.right.bottom.equalToSuperview()
        }
        
        clearAllButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24.0)
        }
    }
    
}
