import UIKit
import SnapKit

class ExpertQAView: RootView {
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 100.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.refreshControl = UIRefreshControl()
        view.backgroundColor = .clear
        
        return view
    }()
    
    let sendButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Задать вопрос", for: .normal)
        
        return button
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(collectionView)
        addSubview(sendButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(12.0)
        }
    }
    
}
